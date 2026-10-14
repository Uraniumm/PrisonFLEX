# PrisonFLEX

A lightweight FLEX loader for iOS applications.

PrisonFLEX bundles [FLEX](https://github.com/FLEXTool/FLEX) together with a simple loader that allows FLEX to be opened with a three-finger long press anywhere inside the injected application's window.

It is primarily designed for jailed tweak injection environments such as LiveContainer's TweakLoader, but also supports rootless jailbroken devices.

## Support

- iOS 14.0 and newer
  - Older versions may work, but are currently untested.
- Rootless jailbreaks
- Jailed / sideloaded applications using tweak injection
  - Examples include LiveContainer, ESign, Sideloadly, and similar tools.

## Features

- FLEX and the loader bundled into a single tweak
- Three-finger long press gesture to open FLEX
- Compatible with jailed tweak injection
- Compatible with rootless jailbreak environments
- Includes FLEX fixes and improvements used by PrisonFLEX
- Builds against the standard FLEX repository by default
- Supports custom FLEX repositories and branches when building

## Usage

After PrisonFLEX has been injected into an application, launch the app normally.

To open FLEX:

**Long press anywhere in the application using three fingers.**

The FLEX explorer should appear over the application.

## Installing

### Jailed / Sideloaded

Inject `PrisonFLEX.dylib` using your preferred tweak loader.

For example:

- LiveContainer TweakLoader
- ESign
- Sideloadly
- Other compatible dylib injection methods

### Rootless Jailbreak

Install the provided `.deb` package using your preferred package manager or manually install the tweak into the appropriate rootless jailbreak environment.

## Building

PrisonFLEX can be built locally using [Theos](https://theos.dev/) or through the included GitHub Actions workflow.

By default, the build system uses:

- FLEX repository: `https://github.com/FLEXTool/FLEX`
- FLEX branch: `master`

A custom FLEX repository and branch may also be supplied when building.

The build system can produce:

- `PrisonFLEX.dylib` — FLEX bundled with the PrisonFLEX loader
- `libFLEX.dylib` — standalone FLEX library without the PrisonFLEX loader
- Rootless `.deb` packages

## Credits

- [pwnless](https://github.com/pwnless) — original inspiration and core tweak through AutoFLEX. More information can be found [here](https://hope1ess.com/2024/10/09/enhancing-ios-debugging-creating-a-custom-flex-loader-to-any-3rd-party-ios-application/).
- [DGh0st](https://github.com/DGh0st) — three-finger gesture crash fix.
- [FLEXTool](https://github.com/FLEXTool) — FLEX itself.

### Honorable Mentions

- [weiminghuaa](https://github.com/weiminghuaa) — system log fixes.
- [otnielyehezkiel](https://github.com/otnielyehezkiel) — SwiftUI support work.
