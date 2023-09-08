import 'package:json_annotation/json_annotation.dart';

import 'auth_matrix_action_type.dart';

part 'auth_matrix_verify.g.dart';

@JsonSerializable()
class AuthMatrixVerify {
  AuthMatrixVerify({
    required this.action,
    required this.endToEndId,
    required this.transactionId,
    required this.userData,
    required this.payload,
  });
  final AuthMatrixActionType action;
  final String endToEndId;
  final String transactionId;
  final String userData;
  final Map<String, dynamic> payload;

  factory AuthMatrixVerify.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixVerifyFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMatrixVerifyToJson(this);
}
