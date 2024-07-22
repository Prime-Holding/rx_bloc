import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/auth_matrix_method.dart';
import '../../../models/payload/auth_matrix_payload_request.dart';

part 'auth_matrix_otp_payload.g.dart';

@CopyWith()
@JsonSerializable()
class AuthMatrixOTPPayload extends AuthMatrixPayloadRequest
    with EquatableMixin {
  AuthMatrixOTPPayload({
    required this.code,
  });

  final String code;

  @override
  String get type => AuthMatrixMethod.otp.name;

  factory AuthMatrixOTPPayload.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixOTPPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$AuthMatrixOTPPayloadToJson(this);

  @override
  List<Object?> get props => [code, type];

  @override
  bool? get stringify => true;
}
