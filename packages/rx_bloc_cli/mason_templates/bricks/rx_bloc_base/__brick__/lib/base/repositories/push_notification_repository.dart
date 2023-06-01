{{> licence.dart }}

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../assets.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/profile_local_data_source.dart';
import '../data_sources/remote/push_notification_data_source.dart';
import '../models/errors/error_model.dart';
import '../models/request_models/push_message_request_model.dart';
import '../models/request_models/push_notification_data_request_model.dart';

class PushNotificationRepository {
  PushNotificationRepository(
    this._errorMapper,
    this._pushDataSource,
    this._firebaseMessaging,
    this._localDataSource,
  );

  final ErrorMapper _errorMapper;
  final PushNotificationsDataSource _pushDataSource;
  final FirebaseMessaging _firebaseMessaging;
  final ProfileLocalDataSource _localDataSource;

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
  Future<void> sendPushMessage({
    required String message,
    String? title,
    int? delay,
    Map<String, Object?>? data,
    String? pushToken,
  }) =>
      _errorMapper.execute(
        () => _pushDataSource.sendPushMessage(
          PushMessageRequestModel(
            message: message,
            title: title,
            delay: delay ?? 0,
            data: data ?? {},
            pushToken: pushToken,
          ),
        ),
      );

  // Checks if the user has granted permissions for displaying push messages.
  // If called the very first time, the user is asked to grant permissions.
  Future<bool> requestNotificationPermissions() =>
      _errorMapper.execute(() async {
        final settings = await _firebaseMessaging.requestPermission();
        switch (settings.authorizationStatus) {
          case AuthorizationStatus.authorized:
          case AuthorizationStatus.provisional:
            return true;
          case AuthorizationStatus.denied:
            throw GenericErrorModel(I18nErrorKeys.notificationsDisabledMessage);
          case AuthorizationStatus.notDetermined:
            throw GenericErrorModel(I18nErrorKeys.accessDenied);
        }
      });

  Future<String?> getToken({String? vapidKey}) => _errorMapper
      .execute(() => _firebaseMessaging.getToken(vapidKey: vapidKey));

  Future<void> setNotificationSubscribed(bool subscribed) => _errorMapper
      .execute(() => _localDataSource.setNotificationsSubscribed(subscribed));

  Future<void> setNotificationsEnabled(bool enabled) => _errorMapper
      .execute(() => _localDataSource.setNotificationsEnabled(enabled));

  Future<bool> notificationsSubscribed() =>
      _errorMapper.execute(() => _localDataSource.notificationsSubscribed());
}
