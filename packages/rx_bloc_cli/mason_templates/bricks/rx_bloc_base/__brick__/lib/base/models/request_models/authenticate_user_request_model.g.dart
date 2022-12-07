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
        AuthUserRequestModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'refreshToken': instance.refreshToken,
    };
