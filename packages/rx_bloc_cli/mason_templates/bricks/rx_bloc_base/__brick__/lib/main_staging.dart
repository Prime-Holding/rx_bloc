{{#uses_firebase}}import 'package:firebase_core/firebase_core.dart';{{/uses_firebase}}
import 'package:flutter/material.dart';

import 'base/app/config/environment_config.dart';
import 'base/app/{{project_name}}.dart';
import 'base/utils/helpers.dart';

// ignore_for_file: avoid_void_async

/// Main entry point for the staging environment
void main() async {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.dev/testing/ for more info.
  // enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  {{#uses_firebase}}
  // TODO: Add Firebase credentials for staging environment for Android and iOS
  await safeRun(()=>Firebase.initializeApp());{{/uses_firebase}}

  runApp({{#pascalCase}}{{project_name}}{{/pascalCase}}(config: EnvironmentConfig.staging));
}
