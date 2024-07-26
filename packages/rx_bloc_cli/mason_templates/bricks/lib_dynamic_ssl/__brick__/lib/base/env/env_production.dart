import 'package:envied/envied.dart';

import 'app_env.dart';
import 'app_env_fields.dart';

part 'env_production.g.dart';

@Envied(name: 'Env', path: '.env_production', obfuscate: true)
final class EnvProduction implements AppEnv, AppEnvFields {
  EnvProduction();

  @override
  @EnviedField()
  final String sslPrivateKey = _Env.sslPrivateKey;
}
