{{> licence.dart }}

import '../repositories/push_notification_repository.dart';

class PushNotificationsService {
  PushNotificationsService(
    this._pushNotificationRepository,
  );
  final PushNotificationRepository _pushNotificationRepository;

  Future<void> syncNotificationSettings() async {
    final areNotificationsEnabledDevice =
        await _pushNotificationRepository.areNotificationsEnabledDevice();
    final areNotificationsEnabledUser =
        await _pushNotificationRepository.notificationsEnabledUser();
    final isDeviceSubscribed =
        await _pushNotificationRepository.notificationsSubscribed();

    if (!areNotificationsEnabledDevice && areNotificationsEnabledUser) {
      await _unsubscribe(true);
      return;
    }
    if (areNotificationsEnabledUser && isDeviceSubscribed) {
      await _subscribe();
      return;
    }
    await ((areNotificationsEnabledUser && areNotificationsEnabledDevice)
        ? _subscribe()
        : _unsubscribe());
  }
    Future<bool> toggleNotifications() async {
    final areNotificationsSubscribed =
        await _pushNotificationRepository.areNotificationsSubscribed();
    if (areNotificationsSubscribed) {
      await _unsubscribe();
      return false;
    } else {
      await _subscribe();
      return true;
    }
  }
  Future<void> _subscribe() async =>
      await _pushNotificationRepository.subscribeForPushNotifications();

  Future<void> _unsubscribe([bool setNotifications = false]) async =>
      await _pushNotificationRepository
          .unsubscribeForPushNotifications(setNotifications);

  Future<bool> areNotificationsEnabled() async =>
      await _pushNotificationRepository.areNotificationsEnabled();

  Future<bool> requestNotificationPermissions() =>
      _pushNotificationRepository.requestNotificationPermissions();

  Future<bool> areNotificationsSubscribed() =>
      _pushNotificationRepository.areNotificationsSubscribed();
}
