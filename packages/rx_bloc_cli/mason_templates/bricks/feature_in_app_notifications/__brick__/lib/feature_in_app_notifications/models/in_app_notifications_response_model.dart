import 'package:json_annotation/json_annotation.dart';

import 'in_app_notification_model.dart';

part 'in_app_notifications_response_model.g.dart';

@JsonSerializable()
class InAppNotificationsResponseModel {
  InAppNotificationsResponseModel({
    required this.notifications,
    required this.totalCount,
    required this.unreadCount,
  });

  final List<InAppNotificationModel> notifications;
  final int totalCount;
  final int unreadCount;

  factory InAppNotificationsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$InAppNotificationsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InAppNotificationsResponseModelToJson(this);
}
