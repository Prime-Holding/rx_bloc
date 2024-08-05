// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_message_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushMessageRequestModel _$PushMessageRequestModelFromJson(
        Map<String, dynamic> json) =>
    PushMessageRequestModel(
      message: json['message'] as String,
      title: json['title'] as String?,
      delay: (json['delay'] as num?)?.toInt() ?? 0,
      data: json['data'] as Map<String, dynamic>?,
      pushToken: json['pushToken'] as String?,
    );

Map<String, dynamic> _$PushMessageRequestModelToJson(
        PushMessageRequestModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
      'delay': instance.delay,
      'data': instance.data,
      'pushToken': instance.pushToken,
    };
