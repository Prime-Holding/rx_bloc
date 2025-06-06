{{> licence.dart }}

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../assets.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/notifications_local_data_source.dart';
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
  final NotificationsLocalDataSource _localDataSource;

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

  Future<void> _setNotificationSubscribed(bool subscribed) => _errorMapper
      .execute(() => _localDataSource.setNotificationsSubscribed(subscribed));

  Future<bool> notificationsSubscribed() =>
      _errorMapper.execute(_localDataSource.notificationsSubscribed);

  Future<bool> notificationsEnabledUser() =>
      _errorMapper.execute(_localDataSource.notificationsEnabled);

  Future<void> _setNotificationsEnabledUser(bool enabled) => _errorMapper
      .execute(() => _localDataSource.setNotificationsEnabled(enabled));

  Future<bool> areNotificationsEnabledDevice() =>
      _errorMapper.execute(() async =>
          (await _firebaseMessaging.getNotificationSettings())
              .authorizationStatus ==
          AuthorizationStatus.authorized);

  Future<bool> areNotificationsEnabled() async =>
      await notificationsEnabledUser() && await areNotificationsEnabledDevice();

  Future<void> subscribeForPushNotifications() async {
    final deviceNotificationsEnabled = await areNotificationsEnabledDevice();
    if (deviceNotificationsEnabled) {
      await _setNotificationSubscribed(true);
      await _performAction(_pushDataSource.subscribePushToken);
      await _setNotificationsEnabledUser(true);
    } else {
      throw GenericErrorModel(I18nErrorKeys.notificationsDisabledMessage);
    }
  }

  Future<void> unsubscribeForPushNotifications(bool setNotifications) async {
    await _performAction(_pushDataSource.unsubscribePushToken);
    await _setNotificationSubscribed(setNotifications);
    await _setNotificationsEnabledUser(setNotifications);
  }

  Future<void> _performAction(
      Function(PushNotificationDataRequestModel) action) async {
    final token = await getToken();
    if (token != null) {
      final requestModel = PushNotificationDataRequestModel(token);
      return await _errorMapper.execute(() async => action(requestModel));
    }
  }

  Future<bool> areNotificationsSubscribed() async =>
    await _localDataSource.notificationsSubscribed();
}
