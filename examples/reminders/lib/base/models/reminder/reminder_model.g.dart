// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DueDateRange _$DueDateRangeFromJson(Map<String, dynamic> json) => DueDateRange(
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
    );

Map<String, dynamic> _$DueDateRangeToJson(DueDateRange instance) =>
    <String, dynamic>{
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
    };

ReminderModelRequest _$ReminderModelRequestFromJson(
        Map<String, dynamic> json) =>
    ReminderModelRequest(
      filterByDueDateRange: json['filterByDueDateRange'] == null
          ? null
          : DueDateRange.fromJson(
              json['filterByDueDateRange'] as Map<String, dynamic>),
      sort:
          $enumDecodeNullable(_$ReminderModelRequestSortEnumMap, json['sort']),
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 50,
      complete: json['complete'] as bool?,
    );

Map<String, dynamic> _$ReminderModelRequestToJson(
        ReminderModelRequest instance) =>
    <String, dynamic>{
      'filterByDueDateRange': instance.filterByDueDateRange,
      'sort': _$ReminderModelRequestSortEnumMap[instance.sort],
      'page': instance.page,
      'pageSize': instance.pageSize,
      'complete': instance.complete,
    };

const _$ReminderModelRequestSortEnumMap = {
  ReminderModelRequestSort.dueDateDesc: 'dueDateDesc',
  ReminderModelRequestSort.dueDateAsc: 'dueDateAsc',
};

ReminderModelRequestData _$ReminderModelRequestDataFromJson(
        Map<String, dynamic> json) =>
    ReminderModelRequestData(
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      complete: json['complete'] as bool,
      authorId: json['authorId'] as String?,
    );

Map<String, dynamic> _$ReminderModelRequestDataToJson(
        ReminderModelRequestData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'dueDate': instance.dueDate.toIso8601String(),
      'complete': instance.complete,
      'authorId': instance.authorId,
    };

ReminderModel _$ReminderModelFromJson(Map<String, dynamic> json) =>
    ReminderModel(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      complete: json['complete'] as bool,
      authorId: json['authorId'],
    );

Map<String, dynamic> _$ReminderModelToJson(ReminderModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'dueDate': instance.dueDate.toIso8601String(),
      'complete': instance.complete,
      'authorId': instance.authorId,
      'id': instance.id,
    };

ReminderPair _$ReminderPairFromJson(Map<String, dynamic> json) => ReminderPair(
      updated: ReminderModel.fromJson(json['updated'] as Map<String, dynamic>),
      old: ReminderModel.fromJson(json['old'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReminderPairToJson(ReminderPair instance) =>
    <String, dynamic>{
      'updated': instance.updated,
      'old': instance.old,
    };
