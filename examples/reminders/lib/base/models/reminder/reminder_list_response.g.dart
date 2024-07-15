// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderListResponse _$ReminderListResponseFromJson(
        Map<String, dynamic> json) =>
    ReminderListResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => ReminderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReminderListResponseToJson(
        ReminderListResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'totalCount': instance.totalCount,
    };
