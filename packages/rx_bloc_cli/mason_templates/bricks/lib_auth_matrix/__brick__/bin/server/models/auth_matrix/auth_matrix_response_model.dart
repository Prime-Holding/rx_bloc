import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'auth_matrix_action_type.dart';
import 'auth_matrix_status.dart';

part 'auth_matrix_response_model.g.dart';

@CopyWith()
@JsonSerializable()
class AuthMatrixResponseModel {
  const AuthMatrixResponseModel({
    required this.transactionId,
    required this.authZ,
    required this.status,
  });

  final String transactionId;
  final AuthMatrixActionType authZ;
  final AuthMatrixStatus status;

  factory AuthMatrixResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMatrixResponseModelToJson(this);
}
