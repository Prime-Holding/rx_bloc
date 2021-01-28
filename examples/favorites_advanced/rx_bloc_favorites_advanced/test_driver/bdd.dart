import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:rx_bloc_favorites_advanced/main.dart' as app;

// This is the main entry point of the integration testing
Future<void> main() async {
  // This line enables the extension.
  enableFlutterDriverExtension();

  WidgetsFlutterBinding.ensureInitialized();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  // See https://flutter.dev/testing/ for more info.
  app.main();
}

// To run the integration tests execute the following command from the terminal:
// flutter driver --target=test_driver/bdd.dart ; node test_driver/generate_report.js
//
// For a list of all common steps used for integration tests,
// visit the following link: https://pub.dev/packages/flutter_gherkin
