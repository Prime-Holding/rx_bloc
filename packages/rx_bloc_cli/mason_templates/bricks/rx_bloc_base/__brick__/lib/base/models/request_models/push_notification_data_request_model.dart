{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'push_notification_data_request_model.g.dart';

@JsonSerializable()
class PushNotificationDataRequestModel {
  PushNotificationDataRequestModel(this.pushToken);

  factory PushNotificationDataRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$PushNotificationDataRequestModelFromJson(json);

  final String pushToken;

  Map<String, dynamic> toJson() =>
      _$PushNotificationDataRequestModelToJson(this);
}
