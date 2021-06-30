// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_messaging/firebase_messaging.dart';

import '../data_sources/remote/push_notification_data_source.dart';
import '../models/request_models/push_message_request_model.dart';
import '../models/request_models/push_notification_data_request_model.dart';

class PushNotificationRepository {
  PushNotificationRepository(this._pushDataSource, this._firebaseMessaging);

  final PushNotificationsDataSource _pushDataSource;
  final FirebaseMessaging _firebaseMessaging;

  Future<void> subscribe(String pushToken) => _pushDataSource
      .subscribePushToken(PushNotificationDataRequestModel(pushToken));

  Future<void> unsubscribe(String pushToken) =>
      _pushDataSource.unsubscribePushToken(PushNotificationDataRequestModel(
        pushToken,
      ));

  // Sends a push notification to the server which will be broadcast to all
  // logged in users.
  Future<void> sendPushMessage(
          {required String message, String? title, int? delay}) =>
      _pushDataSource.sendPushMessage(
        PushMessageRequestModel(
          message: message,
          title: title,
          delay: delay ?? 0,
        ),
      );

  // Checks if the user has granted permissions for displaying push messages.
  // If called the very first time, the user is asked to grant permissions.
  Future<bool> requestNotificationPermissions() async {
    final settings = await _firebaseMessaging.requestPermission();
    return settings.authorizationStatus != AuthorizationStatus.denied;
  }

  Future<String?> getToken({String? vapidKey}) =>
      _firebaseMessaging.getToken(vapidKey: vapidKey);
}
