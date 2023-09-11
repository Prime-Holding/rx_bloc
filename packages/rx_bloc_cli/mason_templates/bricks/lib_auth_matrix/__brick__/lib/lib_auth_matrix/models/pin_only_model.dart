{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

import 'action_request.dart';
import 'auth_matrix_action_type.dart';

part 'pin_only_model.g.dart';

@JsonSerializable()
class PinOnlyModel extends ActionRequest {
  PinOnlyModel(super.action, super.endToEndId, this.userData);
  final String userData;

  factory PinOnlyModel.fromJson(Map<String, dynamic> json) =>
      _$PinOnlyModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PinOnlyModelToJson(this);
}
