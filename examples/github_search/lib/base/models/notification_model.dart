// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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

enum NotificationModelType {
  @JsonValue('Profile')
  profile,

  @JsonValue('Dashboard')
  dashboard,
}
