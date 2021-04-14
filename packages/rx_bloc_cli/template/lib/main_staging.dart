import 'package:flutter/material.dart';

import 'base/app/environment_config.dart';
import 'base/app/my_app.dart';

/// Main entry point for the staging environment
void main() {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.dev/testing/ for more info.
  // enableFlutterDriverExtension();

  runApp(MyApp(EnvironmentConfig.staging));
}
