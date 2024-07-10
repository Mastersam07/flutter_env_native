
import 'flutter_env_platform_interface.dart';

class FlutterEnv {
  Future<String?> getPlatformVersion() {
    return FlutterEnvPlatform.instance.getPlatformVersion();
  }
}
