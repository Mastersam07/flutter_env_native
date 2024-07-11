## 0.0.1
* Initial release of flutter_env plugin.
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