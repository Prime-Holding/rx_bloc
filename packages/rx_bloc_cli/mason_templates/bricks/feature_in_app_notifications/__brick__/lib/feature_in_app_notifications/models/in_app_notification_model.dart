import 'package:json_annotation/json_annotation.dart';

part 'in_app_notification_model.g.dart';

@JsonSerializable()
class InAppNotificationModel {
  InAppNotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isUnread,
    this.body,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isUnread;
  final List<dynamic>? body;

  factory InAppNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$InAppNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$InAppNotificationModelToJson(this);
}
