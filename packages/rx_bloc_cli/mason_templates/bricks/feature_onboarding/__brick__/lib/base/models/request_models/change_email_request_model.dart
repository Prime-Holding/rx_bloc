{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'change_email_request_model.g.dart';

@JsonSerializable()
class ChangeEmailRequestModel {
  ChangeEmailRequestModel({
    required this.email,
  });

  /// The new email of the user
  final String email;

  factory ChangeEmailRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeEmailRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChangeEmailRequestModelToJson(this);
}
