{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'password_reset_request_model.g.dart';

@JsonSerializable()
class PasswordResetRequestModel {
  PasswordResetRequestModel(this.token, this.newPassword);

  /// The token received from the email
  final String token;

  /// The new password to be set
  @JsonKey(name: 'new_password')
  final String newPassword;

  factory PasswordResetRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetRequestModelToJson(this);
}
