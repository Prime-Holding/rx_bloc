{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'auth_token_model.g.dart';

@JsonSerializable()
class AuthTokenModel {
  AuthTokenModel(this.token, this.refreshToken);

  final String token;
  final String refreshToken;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);
}
