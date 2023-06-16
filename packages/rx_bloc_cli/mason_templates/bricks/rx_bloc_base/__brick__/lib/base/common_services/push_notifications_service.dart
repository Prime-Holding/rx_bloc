{{> licence.dart }}

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../assets.dart';
import '../models/errors/error_model.dart';
import '../repositories/push_notification_repository.dart';

class PushNotificationsService {
  final PushNotificationRepository _pushNotificationRepository;
  final FirebaseMessaging firebaseMessaging;

  PushNotificationsService(
    this._pushNotificationRepository,
    this.firebaseMessaging,
  );

  Future<void> unsubscribe([bool setNotifications = false]) async {
    final token = await _pushNotificationRepository.getToken();
    if (token == null) {
      throw ErrorModel();
    }
    await _pushNotificationRepository.unsubscribe(token);
    await _pushNotificationRepository
        .setNotificationSubscribed(setNotifications);
  }

  Future<bool> areNotificationsEnabled() async {
    final permissionStatus = await firebaseMessaging.getNotificationSettings();
    final shouldSubscribe =
        await _pushNotificationRepository.notificationsSubscribed();
    switch (permissionStatus.authorizationStatus) {
      case (AuthorizationStatus.authorized):
        if (shouldSubscribe) {
          await subscribe();
          return true;
        }
      case (AuthorizationStatus.denied):
      case (AuthorizationStatus.provisional):
      case (AuthorizationStatus.notDetermined):
        if (shouldSubscribe == true) {
          await unsubscribe(true);
          return false;
        }
      default:
        await unsubscribe();
        return false;
    }
    return false;
  }

  Future<bool> requestNotificationPermissions() =>
      _pushNotificationRepository.requestNotificationPermissions();

  Future<bool> isSubscribed() =>
      _pushNotificationRepository.notificationsSubscribed();

  Future<void> subscribe() async {
    if (!(await _pushNotificationRepository.requestNotificationPermissions())) {
      throw GenericErrorModel(I18nErrorKeys.notificationsDisabledMessage);
    }

    final token = await _pushNotificationRepository.getToken();

    if (token == null) {
      throw GenericErrorModel(I18nErrorKeys.accessDenied);
    }
    await _pushNotificationRepository.subscribe(token);
    await _pushNotificationRepository.setNotificationSubscribed(true);
  }
}
