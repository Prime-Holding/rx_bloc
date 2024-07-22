import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../auth_matrix_payload_response.dart';
part 'auth_matrix_last_login_payload_response.g.dart';

@JsonSerializable()
class AuthMatrixLastLoginPayloadResponse extends AuthMatrixPayloadResponse
    with EquatableMixin {
  final DateTime lastLogin;

  AuthMatrixLastLoginPayloadResponse({required this.lastLogin});

  factory AuthMatrixLastLoginPayloadResponse.fromJson(
          Map<String, dynamic> json) =>
      _$AuthMatrixLastLoginPayloadResponseFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() =>
      _$AuthMatrixLastLoginPayloadResponseToJson(this);

  @override
  AuthMatrixPayloadResponseType get type =>
      AuthMatrixPayloadResponseType.lastLogin;

  @override
  List<Object?> get props => [type, lastLogin];

  @override
  bool? get stringify => true;
}
