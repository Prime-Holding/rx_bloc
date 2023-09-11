{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

import 'action_request.dart';
import 'auth_matrix_action_type.dart';

part 'otp_model.g.dart';

@JsonSerializable()
class OtpModel extends ActionRequest {
  OtpModel(super.action, super.endToEndId, this.userData);
  final String userData;

  factory OtpModel.fromJson(Map<String, dynamic> json) =>
      _$OtpModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OtpModelToJson(this);
}
