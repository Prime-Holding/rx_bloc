import 'package:envied/envied.dart';

import 'app_env.dart';
import 'app_env_fields.dart';

part 'env_development.g.dart';

@Envied(name: 'Env', path: '.env_development', obfuscate: true)
final class EnvDevelopment implements AppEnv, AppEnvFields {
  EnvDevelopment();

  @override
  @EnviedField()
  final String sslPrivateKey = _Env.sslPrivateKey;
}
