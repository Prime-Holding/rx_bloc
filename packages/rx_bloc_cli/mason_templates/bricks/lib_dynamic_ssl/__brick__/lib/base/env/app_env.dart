import '../app/config/app_constants.dart';
import '../app/config/environment_config.dart';
import 'app_env_fields.dart';
import 'env_development.dart';
import 'env_production.dart';
import 'env_sit.dart';
import 'env_test.dart';
import 'env_uat.dart';

abstract interface class AppEnv implements AppEnvFields {
  factory AppEnv(EnvironmentConfig environment) => isTest
      ? EnvTest()
      : switch (environment) {
          EnvironmentConfig.development => EnvDevelopment(),
          EnvironmentConfig.sit => EnvSit(),
          EnvironmentConfig.uat => EnvUat(),
          EnvironmentConfig.production => EnvProduction(),
        };
}
