{{> licence.dart }}

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../assets.dart';
import '../models/errors/error_model.dart';
import '../repositories/push_notification_repository.dart';

class PushNotificationsService {
  final PushNotificationRepository _pushNotificationRepository;

  PushNotificationsService(
    this._pushNotificationRepository,
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

  Future<(bool, NotificationSettings)> getNotificationSettings() async {
    final permissionStatus =
        await _pushNotificationRepository.getNotificationSettings();
    final isSubscribed =
        await _pushNotificationRepository.notificationsSubscribed();
    return (isSubscribed, permissionStatus);
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
