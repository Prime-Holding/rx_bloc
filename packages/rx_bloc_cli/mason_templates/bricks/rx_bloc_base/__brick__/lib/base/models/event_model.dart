{{> licence.dart }}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel with EquatableMixin {
  EventModel({
    required this.type,
    required this.id,
    required this.parentId,
  });

  @JsonKey(unknownEnumValue: EventModelType.dashboard)
  final EventModelType? type;

  final String? id;

  final String? parentId;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, parentId, type];
}

enum EventModelType {
  @JsonValue('Profile')
  profile,

  @JsonValue('Dashboard')
  dashboard,
}