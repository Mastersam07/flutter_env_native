import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_env/flutter_env.dart';
import 'package:flutter_env/flutter_env_platform_interface.dart';
import 'package:flutter_env/flutter_env_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEnvPlatform
    with MockPlatformInterfaceMixin
    implements FlutterEnvPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterEnvPlatform initialPlatform = FlutterEnvPlatform.instance;

  test('$MethodChannelFlutterEnv is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterEnv>());
  });

  test('getPlatformVersion', () async {
    FlutterEnv flutterEnvPlugin = FlutterEnv();
    MockFlutterEnvPlatform fakePlatform = MockFlutterEnvPlatform();
    FlutterEnvPlatform.instance = fakePlatform;

    expect(await flutterEnvPlugin.getPlatformVersion(), '42');
  });
}
