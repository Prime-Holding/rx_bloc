{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'permission_list_model.g.dart';

@JsonSerializable()
class PermissionListModel {
  PermissionListModel({
    required this.item,
  });

  final Map<String, bool> item;

  factory PermissionListModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionListModelFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionListModelToJson(this);
}
