# flutter_env_native

[![pub package](https://img.shields.io/pub/v/flutter_env_native.svg?color=success&style=flat-square)](https://pub.dartlang.org/packages/flutter_env_native)

A plugin/utility that provides compile-time variables for native platform.

> This plugin/utility makes env variables set in `--dart-define` and `--dart-define-from-file` available to the native platforms.

## 🎖 Installing

```yaml
dev_dependencies:
  flutter_env_native: ^0.1.0
```

## 🎮 Setup Guide

## Define .env file

```.env
APP_NAME=batcave
APP_SUFFIX=.dev
MAPS_API_KEY=someKeyString
```

Pass .env file to flutter run/build via `--dart-define-from-file=.env`

> [!WARNING]
> In **iOS \*.xcconfig** has some limitations when it comes to variable values it treats the sequence **//** as a **comment delimiter**, then for example, `https://example.com`, will be `https://` in the code, everything after **//** will be ignored. For solve omit the `https://` while specifying the env variable and prepend the `https://`  in code, read more about the solution [here](https://nshipster.com/xcconfig/#managing-constants-across-different-environments).

## Android Installation

### :open_file_folder: `android/app/build.gradle`

:exclamation: __DO NOT OMIT ANY OF THE FOLLOWING CHANGES__ :exclamation:


```diff
// flutter_env_native
+Project flutter_env_native = project(':flutter_env_native')
+apply from: "${flutter_env_native.projectDir}/envConfig.gradle"
```

### Usage in android manifest file

##### :open_file_folder: `android/app/src/main/AndroidManifest.xml`:

:exclamation: __DO NOT OMIT ANY OF THE FOLLOWING CHANGES__ :exclamation:

```diff
defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "tech.mastersam.flutter_env_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInteger()
        versionName = flutterVersionName

+       resValue "string", "app_name", APP_NAME ?: 'default_name'
    }
```

The above create a string resource with variable `app_name` set to the value of `APP_NAME`

```diff
<application
        android:label="flutter_env_example"
+       android:name="@string/app_name"
        android:icon="@mipmap/ic_launcher">
```

The above sets the android:name to the value of `app_name` in the string resource. The same applies for other `.xml` files.


### Usage in kotlin file

##### :open_file_folder: `android/app/src/main/AndroidManifest.xml`:

:exclamation: __DO NOT OMIT ANY OF THE FOLLOWING CHANGES__ :exclamation:

```diff
defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "tech.mastersam.flutter_env_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInteger()
        versionName = flutterVersionName

+       buildConfigField "String", "APP_NAME", "\"${APP_NAME ?: 'default_name'}\""
    }
```

The above creates the BuildConfig field `APP_NAME` and sets its value to the env variable `APP_NAME` where available and defaults it to `'default_name'`

##### :open_file_folder: `android/.../MainActivity.kt`:

:exclamation: __DO NOT OMIT ANY OF THE FOLLOWING CHANGES__ :exclamation:

```diff
package tech.mastersam.flutter_env_example

import android.os.Bundle
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

         // Access BuildConfig values
+        val appName = BuildConfig.APP_NAME

         // Sample usage to display a toast message
         Toast.makeText(this, "APP_NAME: $appName", Toast.LENGTH_LONG).show()
    }
}

```

## iOS Installation

### :open_file_folder: `ios/Podfile`

:exclamation: __DO NOT OMIT ANY OF THE FOLLOWING CHANGES__ :exclamation:


```diff
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end

+ flutter_env_plugin_path = File.join(Dir.pwd, '.symlinks', 'plugins', 'flutter_env_native', 'ios', 'setup_env.sh')
+ root_dir = File.expand_path('..', Dir.pwd)

+ # Run the setup_env.sh script from the plugin
+ system("sh \"#{flutter_env_plugin_path}\" \"#{root_dir}\"")
end
```

### Usage in plist file

##### :open_file_folder: `info.plist`:

Reference the env variable directly as defined in the .env file

```plist
<key>CFBundleDisplayName</key>
<string>$(APP_NAME)</string>
```

### Usage in swift file

##### :open_file_folder: `AppDelegate.swift`: (any swift file of choice)

```diff
+ var app_name: String = Bundle.main.infoDictionary?["APP_NAME"] as? String ?? ""
  NSLog("\nHere's your app name -> \(app_name)")
```

> [!NOTE]
> Don't forget the **env variable** added in `info.plist` so you can access it in the **swift file.**