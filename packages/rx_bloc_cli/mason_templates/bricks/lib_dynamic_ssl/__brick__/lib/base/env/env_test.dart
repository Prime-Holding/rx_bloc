import 'package:envied/envied.dart';

import 'app_env.dart';
import 'app_env_fields.dart';

part 'env_test.g.dart';

@Envied(name: 'Env', path: '.env_test', obfuscate: true)
final class EnvTest implements AppEnv, AppEnvFields {
  EnvTest();

  @override
  @EnviedField()
  final String sslPrivateKey = _Env.sslPrivateKey;
}
