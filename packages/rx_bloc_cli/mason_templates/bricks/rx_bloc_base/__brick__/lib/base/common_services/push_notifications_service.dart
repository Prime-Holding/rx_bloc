{{> licence.dart }}

import '../repositories/push_notification_repository.dart';

class PushNotificationsService {
  PushNotificationsService(
    this._pushNotificationRepository,
  );
  final PushNotificationRepository _pushNotificationRepository;

 Future<bool> toggleNotifications() async {
    if (!await areNotificationsEnabled()) {
      await requestNotificationPermissions();
    }
    final areSubscribed = await areNotificationsSubscribed();
    if (areSubscribed) {
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
