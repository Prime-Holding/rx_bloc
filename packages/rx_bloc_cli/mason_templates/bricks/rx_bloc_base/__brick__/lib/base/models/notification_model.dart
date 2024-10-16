{{> licence.dart }}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel with EquatableMixin {
  NotificationModel({
    required this.type,
    required this.id,
  });

  @JsonKey(unknownEnumValue: NotificationModelType.dashboard)
  final NotificationModelType? type;

  final String? id;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, type];
}

enum NotificationModelType { {{#enable_profile}}
  @JsonValue('Profile')
  profile, {{/enable_profile}}

  @JsonValue('Dashboard')
  dashboard,
}
