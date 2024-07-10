import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_env_method_channel.dart';

abstract class FlutterEnvPlatform extends PlatformInterface {
  /// Constructs a FlutterEnvPlatform.
  FlutterEnvPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterEnvPlatform _instance = MethodChannelFlutterEnv();

  /// The default instance of [FlutterEnvPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterEnv].
  static FlutterEnvPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterEnvPlatform] when
  /// they register themselves.
  static set instance(FlutterEnvPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
