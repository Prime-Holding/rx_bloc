import 'package:envied/envied.dart';

import 'app_env.dart';
import 'app_env_fields.dart';

part 'env_uat.g.dart';

@Envied(name: 'Env', path: '.env_uat', obfuscate: true)
final class EnvUat implements AppEnv, AppEnvFields {
  EnvUat();

  @override
  @EnviedField()
  final String sslPrivateKey = _Env.sslPrivateKey;
}
