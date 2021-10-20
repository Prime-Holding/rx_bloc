{{> licence.dart }}

import 'package:flutter/material.dart';

import 'base/app/config/environment_config.dart';
import 'base/app/initialization/app_setup.dart';
import 'base/app/{{project_name}}.dart';

// ignore_for_file: avoid_void_async

/// Main entry point for the production environment
void main() async {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.dev/testing/ for more info.
  // enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();

  // Configure global app tools before launching the app
  await configureApp();

  runApp({{#pascalCase}}{{project_name}}{{/pascalCase}}(config: EnvironmentConfig.prod));
}
