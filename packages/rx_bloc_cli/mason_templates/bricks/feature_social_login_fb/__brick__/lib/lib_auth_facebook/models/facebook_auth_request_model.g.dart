// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facebook_auth_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacebookAuthRequestModel _$FacebookAuthRequestModelFromJson(
        Map<String, dynamic> json) =>
    FacebookAuthRequestModel(
      refreshToken: json['refreshToken'] as String?,
      email: json['email'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$FacebookAuthRequestModelToJson(
    FacebookAuthRequestModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('token', instance.token);
  writeNotNull('refreshToken', instance.refreshToken);
  return val;
}
