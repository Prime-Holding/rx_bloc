{{> licence.dart }}

import '../../base/repositories/push_notification_repository.dart';

class NotificationService {
  NotificationService(this._repository);

  final PushNotificationRepository _repository;

  Future<bool> requestNotificationPermissions() =>
      _repository.requestNotificationPermissions();

  Future<String?> getPushToken() =>
      _repository.getToken();
}
