{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

part 'permissions_model.g.dart';

@JsonSerializable()
class PermissionsModel {
  PermissionsModel({
    required this.item,
  });

  final Map<String, bool> item;

  factory PermissionsModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionsModelToJson(this);
}
