import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/in_app_notifications_data_source.dart';
import '../models/in_app_notification_model.dart';
import '../models/in_app_notifications_response_model.dart';

class InAppNotificationsRepository {
  InAppNotificationsRepository(this._dataSource, this._errorMapper);

  final InAppNotificationsDataSource _dataSource;
  final ErrorMapper _errorMapper;

  Future<InAppNotificationsResponseModel> getNotifications({
    required int page,
    required int pageSize,
    bool unreadOnly = false,
  }) =>
      _errorMapper.execute(
        () => _dataSource.getNotifications(page, pageSize, unreadOnly),
      );

  Future<InAppNotificationModel> getNotificationById(String id) =>
      _errorMapper.execute(() => _dataSource.getNotificationById(id));

  Future<InAppNotificationModel> markAsRead(String id) =>
      _errorMapper.execute(() => _dataSource.markAsRead(id));
}
