## 0.1.0
* Fix: handle spaces in project directory paths for iOS setup
> - Updated setup_env.sh script to correctly handle spaces in directory paths by quoting all path references.
> - Modified Podfile to use bash and properly escape paths when calling setup_env.sh.
> - Ensured all paths are correctly quoted in both setup_env.sh and Podfile.

## 0.0.1
* Initial release of flutter_env_native plugin.
* Support multiple Xcode schemes.
* Extract and inserts necessary identifiers from Xcode scheme files dynamically.
* Automatically ignore Environment.xcconfig file.
* Add example project.
* Add docs.

## Unreleased
* Automatically reads environment variables from --dart-define and make available to gradle system.
* Automatically reads environment variables from --dart-define and creates Environment.xcconfig for iOS.
* Includes environment variables in both Debug.xcconfig and Release.xcconfig files.
* Added pre-build script to Xcode schemes to decode and apply environment variables.
* Add script for post pod install process.