// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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

  Future<void> subscribe() async =>
      await _pushNotificationRepository.subscribeForPushNotifications();

  Future<void> unsubscribe([bool setNotifications = false]) async =>
      await _pushNotificationRepository
          .unsubscribeForPushNotifications(setNotifications);

  Future<bool> areNotificationsEnabled() async =>
      await _pushNotificationRepository.areNotificationsEnabled();
}
