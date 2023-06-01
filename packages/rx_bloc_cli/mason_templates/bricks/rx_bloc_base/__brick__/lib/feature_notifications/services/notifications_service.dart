{{> licence.dart }}

import '../../base/repositories/push_notification_repository.dart';

class NotificationService {
  NotificationService(this._repository);

  final PushNotificationRepository _repository;

  Future<void> sendPushMessage({
    required String message,
    String? title,
    int? delay,
    Map<String, Object?>? data,
  }) async {
    final pushToken = await _repository.getToken();
    return _repository.sendPushMessage(
      message: message,
      title: title,
      delay: delay,
      data: data,
      pushToken: pushToken,
    );
  }

  Future<bool> requestNotificationPermissions() =>
      _repository.requestNotificationPermissions();
}
