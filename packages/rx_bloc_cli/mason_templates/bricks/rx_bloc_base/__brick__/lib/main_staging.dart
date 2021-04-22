{{#analytics}}import 'package:firebase_core/firebase_core.dart';{{/analytics}}
import 'package:flutter/material.dart';

import 'base/app/environment_config.dart';
import 'base/app/{{project_name}}.dart';

// ignore_for_file: avoid_void_async

/// Main entry point for the staging environment
void main() async {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.dev/testing/ for more info.
  // enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  {{#analytics}}await Firebase.initializeApp();{{/analytics}}

  runApp({{#pascalCase}}{{project_name}}{{/pascalCase}}(config: EnvironmentConfig.staging));
}
