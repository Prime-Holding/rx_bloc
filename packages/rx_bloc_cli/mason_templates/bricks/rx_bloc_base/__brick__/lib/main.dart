{{> licence.dart }}

import 'base/app/config/environment_config.dart';
import 'base/app/initialization/app_setup.dart';
import 'base/app/{{project_name}}.dart';

/// Main entry point for the production environment
void main() async => await setupAndRunApp(
  (config) => {{project_name.pascalCase()}}(
    config: config,
  ),
  environment: const EnvironmentConfig.production(),
);