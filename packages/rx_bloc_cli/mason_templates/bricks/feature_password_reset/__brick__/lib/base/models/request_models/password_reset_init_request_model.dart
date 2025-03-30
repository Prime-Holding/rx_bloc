{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'password_reset_init_request_model.g.dart';

@JsonSerializable()
class PasswordResetInitRequestModel {
  PasswordResetInitRequestModel(this.email);

  /// The email of the user requesting the password reset
  final String email;

  factory PasswordResetInitRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetInitRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetInitRequestModelToJson(this);
}
