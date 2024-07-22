import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import '../methods/otp/models/auth_matrix_otp_payload.dart';
import '../methods/pin_biometric/models/auth_matrix_pin_code_payload.dart';
import 'auth_matrix_method.dart';
import 'payload/auth_matrix_payload_request.dart';

part 'auth_matrix_method_request.g.dart';

@CopyWith()
class AuthMatrixMethodRequest with EquatableMixin {
  AuthMatrixMethodRequest({
    required this.securityToken,
    required this.payload,
  });

  /// The security token used to authenticate the user and authorize the request.
  final String securityToken;

  /// The request body that contains the necessary user data to authenticate the user.
  final AuthMatrixPayloadRequest payload;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'securityToken': securityToken,
        'payload': payload.toJson(),
      };

  factory AuthMatrixMethodRequest.fromJson(Map<String, dynamic> json) =>
      AuthMatrixMethodRequest(
        securityToken: json['securityToken'],
        payload: _payloadFromJson(json['payload']),
      );

  @override
  List<Object?> get props => [securityToken, payload];

  @override
  bool? get stringify => true;
}

AuthMatrixPayloadRequest _payloadFromJson(
  Map<String, dynamic>? json,
) {
  if (json == null || !json.containsKey('type')) {
    throw ArgumentError('Complete method is not supported');
  }

  final type = AuthMatrixMethod.values.byName(json['type']);

  switch (type) {
    case AuthMatrixMethod.pinBiometric:
      return AuthMatrixPinCodePayload.fromJson(json);
    case AuthMatrixMethod.otp:
      return AuthMatrixOTPPayload.fromJson(json);
    case AuthMatrixMethod.complete:
      throw ArgumentError('Complete method is not supported');
  }
}
