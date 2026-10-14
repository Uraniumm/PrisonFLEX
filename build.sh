#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning up..."
rm -rf FLEX/ src/

echo "Copying sources..."
mkdir -p src/

# Use custom repository URL or FLEX upstream.
FLEX_REPO="${1:-https://github.com/FLEXTool/FLEX}"

# Use custom branch or master.
FLEX_BRANCH="${2:-master}"

BUILD_TARGET="${3:-all}"

echo "Cloning FLEX:"
echo "  repo:   $FLEX_REPO"
echo "  branch: $FLEX_BRANCH"
echo "  target: $BUILD_TARGET"

git clone \
    --depth=1 \
    --branch "$FLEX_BRANCH" \
    "$FLEX_REPO" \
    FLEX

find FLEX/Classes \
    -type f \
    \( -name "*.h" -o -name "*.m" -o -name "*.mm" -o -name "*.c" \) \
    -exec cp {} src/ \;

FILE="src/FLEXSwiftInternal.mm"

test -f "$FILE"

echo "Applying FLEXSwiftInternal compatibility patches..."

# Don't depend on fixed upstream line numbers.
sed -i '' \
    's/std::atomic<mask_t> _maybeMask;/mask_t _maybeMask;/' \
    "$FILE"

sed -i '' \
    's/std::atomic<preopt_cache_t \*> _originalPreoptCache;/preopt_cache_t * _originalPreoptCache;/' \
    "$FILE"

# Make absolutely sure the expected result exists.
grep -Fq 'mask_t _maybeMask;' "$FILE"
grep -Fq 'preopt_cache_t * _originalPreoptCache;' "$FILE"

echo "Building target: $BUILD_TARGET"

mkdir -p packages

rm -f packages/*.deb
rm -f packages/PrisonFLEX.dylib
rm -f packages/libFLEX.dylib

make clean

case "$BUILD_TARGET" in
    all)
        echo "Building PrisonFLEX + libFLEX..."
        make package
        ;;

    PrisonFLEX)
        echo "Building PrisonFLEX only..."
        make all \
            TWEAK_NAME=PrisonFLEX \
            LIBRARY_NAME=
        ;;

    libFLEX)
        echo "Building standalone libFLEX only..."
        make all \
            TWEAK_NAME= \
            LIBRARY_NAME=libFLEX
        ;;

    *)
        echo "ERROR: Unknown build target: $BUILD_TARGET"
        echo "Valid targets: all, PrisonFLEX, libFLEX"
        exit 1
        ;;

esac

if [[ "$BUILD_TARGET" == "all" || "$BUILD_TARGET" == "PrisonFLEX" ]]; then
    PRISONFLEX_PATH="$(
        find .theos/obj \
            -type f \
            -name 'PrisonFLEX.dylib' \
            -print \
            | head -n 1
    )"

    if [[ -z "$PRISONFLEX_PATH" || ! -s "$PRISONFLEX_PATH" ]]; then
        echo "ERROR: PrisonFLEX.dylib was not produced"
        exit 1
    fi

    cp "$PRISONFLEX_PATH" packages/PrisonFLEX.dylib

    echo
    echo "=== PrisonFLEX ==="
    file packages/PrisonFLEX.dylib
    ls -lh packages/PrisonFLEX.dylib
fi


if [[ "$BUILD_TARGET" == "all" || "$BUILD_TARGET" == "libFLEX" ]]; then
    LIBFLEX_PATH="$(
        find .theos/obj \
            -type f \
            -name 'libFLEX.dylib' \
            -print \
            | head -n 1
    )"

    if [[ -z "$LIBFLEX_PATH" || ! -s "$LIBFLEX_PATH" ]]; then
        echo "ERROR: libFLEX.dylib was not produced"
        exit 1
    fi

    cp "$LIBFLEX_PATH" packages/libFLEX.dylib

    echo
    echo "=== libFLEX ==="
    file packages/libFLEX.dylib
    ls -lh packages/libFLEX.dylib

    echo
    echo "=== libFLEX dependencies ==="
    otool -L packages/libFLEX.dylib
fi

echo
echo "Build complete."
