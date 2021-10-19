// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

{{#uses_firebase}}
import 'package:firebase_core/firebase_core.dart';{{/uses_firebase}}{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';{{/push_notifications}}

import '../../utils/helpers.dart';{{#push_notifications}}
import 'firebase_messaging_callbacks.dart';{{/push_notifications}}


/// Configures application tools and packages before running the app. Services
/// such as Firebase or background handlers can be defined here.
Future configureApp() async {
  {{#uses_firebase}}
  // TODO: Add Firebase credentials for used environments
  // That is for development, staging and production for Android, iOS and Web
  await safeRun(() => Firebase.initializeApp());{{/uses_firebase}}{{#push_notifications}}
  await _setupNotifications();{{/push_notifications}}

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
{{/push_notifications}}