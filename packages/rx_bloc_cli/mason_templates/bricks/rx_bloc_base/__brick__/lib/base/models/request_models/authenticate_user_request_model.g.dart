// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_user_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserRequestModel _$AuthUserRequestModelFromJson(
    Map<String, dynamic> json) =>
    AuthUserRequestModel(
      username: json['username'] as String?,
      password: json['password'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$AuthUserRequestModelToJson(
    AuthUserRequestModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('username', instance.username);
  writeNotNull('password', instance.password);
  writeNotNull('refreshToken', instance.refreshToken);
  return val;
}
