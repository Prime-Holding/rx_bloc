// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/local_notifications.dart';

/// Callback executed once the app receives a FCM message while in foreground
Future<void> onForegroundMessage(
    BuildContext context, RemoteMessage message) async {
  print('Foreground Message received!');
  final notification = message.notification;

  if (notification != null) {
    final androidNotification = notification.android;
    final title = notification.title ?? '';
    final body = notification.body ?? '';

    // Present the foreground notification on Android only
    // https://firebase.flutter.dev/docs/messaging/notifications/#application-in-foreground
    if (!kIsWeb && androidNotification != null) {
      await showLocalNotification(
        id: notification.hashCode,
        title: title,
        content: body,
      );
    } else if (kIsWeb) {
      // TODO: Implement your own logic of presenting notifications on web
      print('Web notification received: ');
      print('$title : $body');
    }
  }
}

/// Callback executed once the app receives a FCM message while in background
/// or when the app is terminated. Note here that no build context is provided,
/// as the app is running in headless state (without a GUI).
Future<void> onBackgroundMessage(RemoteMessage message) async {
  //If using other Firebase services, make sure that the Firebase is initialized
  await Firebase.initializeApp();

  print('Background Message received!');
}

/// Callback executed if the app has opened from a background state (and was
/// not terminated).
Future<void> onMessageOpenedFromBackground(
    BuildContext context, RemoteMessage message) async {
  print('Message opened from background.');
}

/// If the application has been opened from a terminated state via a remote
/// message (containing a notification), it will be returned, otherwise it will
/// be `null`.
Future<void> onInitialMessageOpened(
    BuildContext context, RemoteMessage? message) async {
  print('Initial message exists: ${message != null}');
}

/// Callback triggered once a new FCM token is generated
Future<void> onFCMTokenRefresh(BuildContext context, String token) async {
  print('New FCM token: $token');
}

