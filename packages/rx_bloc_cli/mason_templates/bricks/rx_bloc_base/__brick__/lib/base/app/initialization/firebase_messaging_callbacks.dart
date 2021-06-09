{{#push_notifications}}
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../utils/local_notifications.dart';

/// Callback executed once the app receives a FCM message while in foreground
Future<void> onForegroundMessage(RemoteMessage message) async {
  print('Foreground Message received!');
  final notification = message.notification;
  final android = message.notification?.android;

  // Present the foreground notification on Android only
  // https://firebase.flutter.dev/docs/messaging/notifications/#application-in-foreground
  if (notification != null && android != null && !kIsWeb) {
    await showLocalNotification(
      id: notification.hashCode,
      title: notification.title,
      content: notification.body,
    );
  }
}

/// Callback executed once the app receives a FCM message while in background
/// or when the app is terminated
Future<void> onBackgroundMessage(RemoteMessage message) async {
  //If using other Firebase services, make sure that the Firebase is initialized
  await Firebase.initializeApp();

  print('Background Message received!');
}

/// Callback executed if the app has opened from a background state
/// (not terminated).
Future<void> onMessageOpenedFromBackground(RemoteMessage message) async {
  print('Message opened from background.');
}

/// If the application has been opened from a terminated state via a remote
/// message (containing a notification), it will be returned, otherwise it will
/// be `null`.
Future<void> onInitialMessageOpened(RemoteMessage? message) async {
  print('Initial message exists: ${message != null}');
}

/// Callback triggered once a new FCM token is generated
Future<void> onFCMTokenRefresh(String token) async {
  print('New FCM token: $token');
}

{{/push_notifications}}