import 'base/app/booking_app.dart';
import 'base/app/config/environment_config.dart';
import 'base/app/initialization/app_setup.dart';

/// Main entry point for the production environment
void main() async => await setupAndRunApp(
      (config) => MyApp(
        config: config,
      ),
      environment: EnvironmentConfig.development,
    );
