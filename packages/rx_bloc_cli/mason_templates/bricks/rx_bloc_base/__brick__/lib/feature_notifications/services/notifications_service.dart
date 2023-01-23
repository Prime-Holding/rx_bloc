{{> licence.dart }}

import '../../base/repositories/push_notification_repository.dart';

class NotificationService {
  NotificationService(this._repository);

  final PushNotificationRepository _repository;

  Future<void> sendPushMessage({
    required String message,
    String? title,
    int? delay,
  }) =>
      _repository.sendPushMessage(
        message: message,
        title: title,
        delay: delay,
      );

  Future<bool> requestNotificationPermissions() =>
      _repository.requestNotificationPermissions();
}
