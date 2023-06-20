{{> licence.dart }}

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
    await _pushNotificationRepository
        .setNotificationsEnabledUser(setNotifications);
  }

  Future<bool> areNotificationsEnabled() async {
    final enabled =
        await _pushNotificationRepository.areNotificationsEnabledDevice();
    final subscribed =
        await _pushNotificationRepository.notificationsEnabledUser();
    return enabled && subscribed;
  }

  Future<void> syncNotificationSettings() async {
    final areNotificationsEnabledDevice =
        await _pushNotificationRepository.areNotificationsEnabledDevice();
    final areNotificationsEnabledUser =
        await _pushNotificationRepository.notificationsEnabledUser();
    final isDeviceSubscribed =
        await _pushNotificationRepository.notificationsSubscribed();

    if (!areNotificationsEnabledDevice && areNotificationsEnabledUser) {
      await unsubscribe(true);
      return;
    }
    if (areNotificationsEnabledUser && isDeviceSubscribed) {
      await subscribe();
      return;
    }
    await ((areNotificationsEnabledUser && areNotificationsEnabledDevice)
        ? subscribe()
        : unsubscribe());
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
    await _pushNotificationRepository.setNotificationsEnabledUser(true);
  }
}
