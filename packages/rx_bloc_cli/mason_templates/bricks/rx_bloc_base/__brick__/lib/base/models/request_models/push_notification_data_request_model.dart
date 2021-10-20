{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'push_notification_data_request_model.g.dart';

@JsonSerializable()
class PushNotificationDataRequestModel {
  PushNotificationDataRequestModel(this.pushToken);

  final String pushToken;

  factory PushNotificationDataRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$PushNotificationDataRequestModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$PushNotificationDataRequestModelToJson(this);
}
