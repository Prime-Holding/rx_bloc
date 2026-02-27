import '../models/in_app_notification_model.dart';
import '../models/in_app_notifications_response_model.dart';
import '../repositories/in_app_notifications_repository.dart';

class InAppNotificationsService {
  InAppNotificationsService(this._repository);

  final InAppNotificationsRepository _repository;

  Future<InAppNotificationsResponseModel> getNotifications({
    required int page,
    required int pageSize,
    bool unreadOnly = false,
  }) =>
      _repository.getNotifications(
        page: page,
        pageSize: pageSize,
        unreadOnly: unreadOnly,
      );

  Future<InAppNotificationModel> getNotificationById(String id) =>
      _repository.getNotificationById(id);

  Future<InAppNotificationModel> markAsRead(String id) =>
      _repository.markAsRead(id);

  Future<int> getUnreadCount() async {
    final response = await _repository.getNotifications(
      page: 0,
      pageSize: 1,
    );
    return response.unreadCount;
  }
}
