{{> licence.dart }}

import 'package:firebase_messaging/firebase_messaging.dart';

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/push_notification_data_source.dart';
import '../models/request_models/push_message_request_model.dart';
import '../models/request_models/push_notification_data_request_model.dart';

class PushNotificationRepository {
  PushNotificationRepository(
    this._errorMapper,
    this._pushDataSource,
    this._firebaseMessaging,
  );

  final ErrorMapper _errorMapper;
  final PushNotificationsDataSource _pushDataSource;
  final FirebaseMessaging _firebaseMessaging;

  Future<void> subscribe(String pushToken) => _errorMapper.execute(
        () => _pushDataSource
            .subscribePushToken(PushNotificationDataRequestModel(pushToken)),
      );

  Future<void> unsubscribe(String pushToken) => _errorMapper.execute(
        () => _pushDataSource
            .unsubscribePushToken(PushNotificationDataRequestModel(pushToken)),
      );

  // Sends a push notification to the server which will be broadcast to all
  // logged in users.
  Future<void> sendPushMessage(
          {required String message, String? title, int? delay}) =>
      _errorMapper.execute(() => _pushDataSource.sendPushMessage(
            PushMessageRequestModel(
              message: message,
              title: title,
              delay: delay ?? 0,
            ),
          ));

  // Checks if the user has granted permissions for displaying push messages.
  // If called the very first time, the user is asked to grant permissions.
  Future<bool> requestNotificationPermissions() =>
      _errorMapper.execute(() async {
        final settings = await _firebaseMessaging.requestPermission();
        return settings.authorizationStatus != AuthorizationStatus.denied;
      });

  Future<String?> getToken({String? vapidKey}) => _errorMapper
      .execute(() => _firebaseMessaging.getToken(vapidKey: vapidKey));
}
