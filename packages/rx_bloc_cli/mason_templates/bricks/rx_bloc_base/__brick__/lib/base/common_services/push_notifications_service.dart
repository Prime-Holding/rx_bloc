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

  Future<bool> requestNotificationPermissions() async =>
      await _pushNotificationRepository.requestNotificationPermissions();

  Future<void> subscribe() async =>
      await _pushNotificationRepository.subscribeForPushNotifications();

  Future<void> unsubscribe([bool setNotifications = false]) async =>
      await _pushNotificationRepository
          .unsubscribeForPushNotifications(setNotifications);

  Future<bool> areNotificationsEnabled() async =>
      await _pushNotificationRepository.areNotificationsEnabled();
}
