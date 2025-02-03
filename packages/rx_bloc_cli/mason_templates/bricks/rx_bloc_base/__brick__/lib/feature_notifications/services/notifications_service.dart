{{> licence.dart }}

import '../../base/models/errors/error_model.dart';
import '../../base/repositories/push_notification_repository.dart';

class NotificationService {
  NotificationService(this._repository);

  final PushNotificationRepository _repository;

  Future<String> getPushToken() async =>
      await _repository.getToken() ?? (throw NotFoundErrorModel());
}
