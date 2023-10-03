import 'package:flutter/material.dart';

import '../config/environment_config.dart';

/// This is the main entry point of the app which performs any setups before
/// running the app.
Future<void> setupAndRunApp(
  Widget Function(EnvironmentConfig) appBuilder, {
  required EnvironmentConfig environment,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Configure global app tools before launching the app
  await configureApp(environment);

  // Build the widget
  final appWidget = appBuilder(environment);

  // Finally run the widget
  runApp(appWidget);
}

/// Configures application tools and packages before running the app. Services
/// such as Firebase or background handlers can be configured here.
Future configureApp(EnvironmentConfig envConfig) async {
  // TODO: Add your own code that is going to be run before the actual app
}
