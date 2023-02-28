// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.



import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/helpers.dart';
import '../config/environment_config.dart';
import 'firebase_messaging_callbacks.dart';

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
  //  containing the actual configuration values.
  //  https://firebase.google.com/docs/flutter/setup
  await safeRun(() => Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'apiKey',
          appId: 'appId',
          messagingSenderId: 'messagingSenderId',
          projectId: 'projectId',
        ),
      ));
  await _setupNotifications();

  // TODO: Add your own code that is going to be run before the actual app
}


/// Configures Firebase notifications
Future<void> _setupNotifications() async {
  // TODO: Request permissions for iOS or Web

  if (!kIsWeb) {
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  // In order to receive notifications when the app is in background or
  // terminated, you need to pass a callback to onBackgroundMessage method
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
}

