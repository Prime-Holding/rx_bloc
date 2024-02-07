{{> licence.dart }}

{{#uses_firebase}}
import 'package:firebase_core/firebase_core.dart';{{/uses_firebase}}{{#analytics}}
import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/analytics}}{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';{{/push_notifications}}
import 'package:flutter/material.dart';
import '../../utils/helpers.dart';
import '../config/environment_config.dart';{{#push_notifications}}
import 'firebase_messaging_callbacks.dart';{{/push_notifications}}

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
  await _setupNotifications();{{#analytics}}
  await _setupCrashlytics();{{/analytics}}
  // TODO: Add your own code that is going to be run before the actual app
}
{{#push_notifications}}

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
{{/push_notifications}}{{#analytics}}

Future<void> _setupCrashlytics() async {
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
{{/analytics}}
