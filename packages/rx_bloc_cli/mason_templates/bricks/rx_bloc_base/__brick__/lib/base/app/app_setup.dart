// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
{{#push_notifications}}
import 'dart:io';{{/push_notifications}}

{{#uses_firebase}}
import 'package:firebase_core/firebase_core.dart';{{/uses_firebase}}{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';{{/push_notifications}}

import '../utils/helpers.dart';
{{#push_notifications}}

// ignore_for_file: cancel_subscriptions{{/push_notifications}}

Future configureApp() async {
  {{#uses_firebase}}
  // TODO: Add Firebase credentials for used environments
  // That is for development, staging and production for Android, iOS and Web
  await safeRun(() => Firebase.initializeApp());{{/uses_firebase}}{{#push_notifications}}
  await _setupNotifications();{{/push_notifications}}

  // TODO: Add your own code that is going to be run before the actual app
}

{{#push_notifications}}
void _onForegroundMessage(RemoteMessage message) async {
  print('Foreground Message received!');
  final plugin = await getNotificationPlugin();
  final notification = message.notification;
  final android = message.notification?.android;

  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  if (notification != null && android != null) {
    await plugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          icon: android.smallIcon,
          // other properties...
        ),
      ));
  }
}

Future<void> _onBackgroundMessage(RemoteMessage message) async {
  //Firebase.initializeApp();
  print('Background Message received!');
}

Future<void> _setupNotifications() async {
  // TODO: Request permissions for iOS or Web
  // On Android, this works out of the box

  if (Platform.isIOS) {
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
    );
  }

  // TODO: How do we dispose of the stream?
  // Disposing of it while in app means that we don't want to listen to it.
  // However, without disposing it, we create potential memory leaks!
  final subscription = FirebaseMessaging.onMessage.listen(_onForegroundMessage);

  //subscription.cancel(); // Cancel it when the app is terminated somehow?
  // Maybe this https://api.flutter.dev/flutter/widgets/WidgetsBindingObserver-class.html ?

  // In order to receive notifications when the app is in background or
  // terminated, you need to pass a callback to onBackgroundMessage method
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
}

const channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

Future<FlutterLocalNotificationsPlugin> getNotificationPlugin() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  return flutterLocalNotificationsPlugin;
}
{{/push_notifications}}