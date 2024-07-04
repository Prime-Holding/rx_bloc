// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../utils/helpers.dart';
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
  // TODO: Use flutterfire_cli to create the firebase_options.dart file
  // containing the actual configuration values.
  // https://firebase.google.com/docs/flutter/setup
  //
  // Below is a minimal configuration of the firebase config to make the project
  // work out of the box. Please replace it with your own values.
  await safeRun(() => Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AAaaAaAAaa0aa0AA_aAAA0a0a0a0AaOaAaA0aAA',
          appId: '1:0123456789012:ios:a00000000a0000a0000a0a',
          messagingSenderId: 'replace_me',
          projectId: 'replace_me',
        ),
      ));
}
