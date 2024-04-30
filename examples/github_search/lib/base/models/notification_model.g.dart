// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      type: $enumDecodeNullable(_$NotificationModelTypeEnumMap, json['type'],
          unknownValue: NotificationModelType.dashboard),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'type': _$NotificationModelTypeEnumMap[instance.type],
      'id': instance.id,
    };

const _$NotificationModelTypeEnumMap = {
  NotificationModelType.profile: 'Profile',
  NotificationModelType.dashboard: 'Dashboard',
};
