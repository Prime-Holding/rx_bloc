import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../models/in_app_notification_model.dart';
import '../models/in_app_notifications_response_model.dart';

part 'in_app_notifications_data_source.g.dart';

@RestApi()
abstract class InAppNotificationsDataSource {
  
  factory InAppNotificationsDataSource(Dio dio, {String baseUrl}) =
      _InAppNotificationsDataSource;

  @GET('/api/in-app-notifications')
  Future<InAppNotificationsResponseModel> getNotifications(
    @Query('page') int page,
    @Query('pageSize') int pageSize,
    @Query('unreadOnly') bool unreadOnly,
  );

  @GET('/api/in-app-notifications/{id}')
  Future<InAppNotificationModel> getNotificationById(@Path('id') String id);

  @PATCH('/api/in-app-notifications/{id}/read')
  Future<InAppNotificationModel> markAsRead(@Path('id') String id);
}
