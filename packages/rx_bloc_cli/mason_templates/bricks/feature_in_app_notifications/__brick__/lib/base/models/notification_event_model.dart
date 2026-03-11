{{ >license.dart }}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_event_model.g.dart';

@JsonSerializable()
class NotificationEvent with EquatableMixin {
  NotificationEvent({required this.type});

  final NotificationEventType type;

  factory NotificationEvent.fromJson(Map<String, dynamic> json) =>
      _$NotificationEventFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationEventToJson(this);

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [type];
}

enum NotificationEventType {
  @JsonValue('newNotification')
  newNotification,
}
