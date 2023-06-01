{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'push_message_request_model.g.dart';

@JsonSerializable()
class PushMessageRequestModel {
    PushMessageRequestModel({
    required this.message,
    this.title,
    this.delay = 0,
    this.data,
    this.pushToken,
  });

  final String? title;
  final String message;
  final int delay;
  final Map<String, Object?>? data;
  final String? pushToken;

  factory PushMessageRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PushMessageRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$PushMessageRequestModelToJson(this);
}
