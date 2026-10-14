FINALPACKAGE=1
GO_EASY_ON_ME=1

TARGET = iphone:clang:16.5:15.0
ARCHS = arm64
THEOS_PACKAGE_SCHEME=rootless

include $(THEOS)/makefiles/common.mk

TARGET_CC = xcrun -sdk iphoneos clang
TARGET_CXX = xcrun -sdk iphoneos clang++
TARGET_LD = xcrun -sdk iphoneos clang++

# FLEX sources copied into src/ by build.sh
FLEX_FILES := $(wildcard src/*.m src/*.mm src/*.c)

FLEX_CFLAGS = \
	-Isrc \
	-fobjc-arc \
	-Wno-deprecated-declarations \
	-Wno-strict-prototypes \
	-Wno-unsupported-availability-guard \
	-Wno-unused-but-set-variable

FLEX_FRAMEWORKS = \
	UIKit \
	CoreGraphics \
	QuartzCore \
	ImageIO \
	WebKit \
	Security \
	SceneKit \
	AVFoundation \
	UserNotifications

FLEX_LDFLAGS = -lz -lsqlite3


# ---------------------------------------------------------
# PrisonFLEX
# Full tweak: FLEX + Tweak.x loader/hooks
# ---------------------------------------------------------

TWEAK_NAME = PrisonFLEX

PrisonFLEX_FILES = Tweak.x $(FLEX_FILES)
PrisonFLEX_CFLAGS = $(FLEX_CFLAGS)
PrisonFLEX_FRAMEWORKS = $(FLEX_FRAMEWORKS)
PrisonFLEX_LDFLAGS = $(FLEX_LDFLAGS)

include $(THEOS_MAKE_PATH)/tweak.mk


# ---------------------------------------------------------
# libFLEX
# Raw FLEX library for manual dlopen / LiveContainer
# ---------------------------------------------------------

LIBRARY_NAME = libFLEX

libFLEX_FILES = $(FLEX_FILES)
libFLEX_CFLAGS = $(FLEX_CFLAGS)
libFLEX_FRAMEWORKS = $(FLEX_FRAMEWORKS)
libFLEX_LDFLAGS = $(FLEX_LDFLAGS)

# Don't put the standalone library into the PrisonFLEX deb.
# We only want the raw dylib as a build artifact.
libFLEX_INSTALL = 0

# Give it a portable dylib ID.
libFLEX_LDFLAGS += -install_name @rpath/libFLEX.dylib

include $(THEOS_MAKE_PATH)/library.mk

.PHONY: clean-artifacts clean-all

clean-artifacts:
	@echo "Cleaning PrisonFLEX build artifacts..."
#	rm -f packages/*.deb
#	rm -f packages/PrisonFLEX.dylib
#	rm -f packages/libFLEX.dylib
	rm -rf packages
	rm -rf src

clean-all: clean clean-artifacts
