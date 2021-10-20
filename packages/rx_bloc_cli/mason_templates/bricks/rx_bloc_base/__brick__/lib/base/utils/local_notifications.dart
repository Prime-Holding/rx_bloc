{{> licence.dart }}

import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notification plugin handle that is used for displaying the notifications
FlutterLocalNotificationsPlugin? _notificationsPlugin;

/// Channel used for displaying heads-up notifications on Android
const _maxImportanceChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
);

/// Initializes and returns the notification plugin
Future<FlutterLocalNotificationsPlugin?> _getNotificationPlugin() async {
  bool isInit = _notificationsPlugin != null;

  if (!isInit) {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isAndroid) {
      await _notificationsPlugin
          ?.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_maxImportanceChannel);
    }
  }

  return _notificationsPlugin;
}

/// Displays a local notification with provided contents
Future<void> showLocalNotification({
  required int id,
  String? title,
  String? content,
  String? icon,
  String? payload,
}) async {
  final plugin = await _getNotificationPlugin();
  await plugin?.show(
    id,
    title ?? '',
    content ?? '',
    NotificationDetails(
      android: AndroidNotificationDetails(
        _maxImportanceChannel.id,
        _maxImportanceChannel.name,
        channelDescription: _maxImportanceChannel.description,
        icon: icon ?? 'app_icon', // To use your own custom icon for foreground
        // notifications, replace the png file in `android/src/main/res/drawable`
      ),
      iOS: const IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
    payload: payload,
  );
}
