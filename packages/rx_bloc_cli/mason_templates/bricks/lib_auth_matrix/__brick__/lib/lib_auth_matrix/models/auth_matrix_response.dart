import 'package:json_annotation/json_annotation.dart';

import 'auth_matrix_action_type.dart';

part 'auth_matrix_response.g.dart';

@JsonSerializable()
class AuthMatrixResponse {
  AuthMatrixResponse(this.transactionId, this.authZ, this.status);

  final String transactionId;
  @JsonKey(unknownEnumValue: AuthMatrixActionType.none)
  final AuthMatrixActionType authZ;
  @JsonKey(unknownEnumValue: AuthMatrixStatus.unknown)
  final AuthMatrixStatus status;

  factory AuthMatrixResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMatrixResponseToJson(this);
}

enum AuthMatrixStatus {
  unknown,
  inProgress,
  forbidden,
  authorized,
}
