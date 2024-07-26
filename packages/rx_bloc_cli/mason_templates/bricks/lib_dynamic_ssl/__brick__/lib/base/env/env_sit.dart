import 'package:envied/envied.dart';

import 'app_env.dart';
import 'app_env_fields.dart';

part 'env_sit.g.dart';

@Envied(name: 'Env', path: '.env_sit', obfuscate: true)
final class EnvSit implements AppEnv, AppEnvFields {
  EnvSit();

  @override
  @EnviedField()
  final String sslPrivateKey = _Env.sslPrivateKey;
}
