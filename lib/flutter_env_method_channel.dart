import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_env_platform_interface.dart';

/// An implementation of [FlutterEnvPlatform] that uses method channels.
class MethodChannelFlutterEnv extends FlutterEnvPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_env');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
