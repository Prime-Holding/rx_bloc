{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'authenticate_user_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class AuthUserRequestModel {
  AuthUserRequestModel({this.username, this.password, this.refreshToken});

  final String? username;
  final String? password;
  final String? refreshToken;

  factory AuthUserRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthUserRequestModelToJson(this);
}
