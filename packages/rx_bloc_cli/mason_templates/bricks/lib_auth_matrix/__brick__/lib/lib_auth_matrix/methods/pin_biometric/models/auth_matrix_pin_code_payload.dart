import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/auth_matrix_method.dart';
import '../../../models/payload/auth_matrix_payload_request.dart';

part 'auth_matrix_pin_code_payload.g.dart';

@CopyWith()
@JsonSerializable()
class AuthMatrixPinCodePayload extends AuthMatrixPayloadRequest
    with EquatableMixin {
  AuthMatrixPinCodePayload({required this.code});

  final String code;

  @override
  String get type => AuthMatrixMethod.pinBiometric.name;

  factory AuthMatrixPinCodePayload.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixPinCodePayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() =>
      _$AuthMatrixPinCodePayloadToJson(this);

  @override
  List<Object?> get props => [code];

  @override
  bool? get stringify => true;
}
