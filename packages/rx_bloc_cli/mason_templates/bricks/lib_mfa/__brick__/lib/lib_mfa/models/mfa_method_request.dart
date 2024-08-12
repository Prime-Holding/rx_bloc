import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import '../methods/otp/models/mfa_otp_payload.dart';
import '../methods/pin_biometric/models/mfa_pin_code_payload.dart';
import 'mfa_method.dart';
import 'payload/mfa_payload_request.dart';

part 'mfa_method_request.g.dart';

@CopyWith()
class MfaMethodRequest with EquatableMixin {
  MfaMethodRequest({
    required this.securityToken,
    required this.payload,
  });

  /// The security token used to authenticate the user and authorize the request.
  final String securityToken;

  /// The request body that contains the necessary user data to authenticate the user.
  final MfaPayloadRequest payload;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'securityToken': securityToken,
        'payload': payload.toJson(),
      };

  factory MfaMethodRequest.fromJson(Map<String, dynamic> json) =>
      MfaMethodRequest(
        securityToken: json['securityToken'],
        payload: _payloadFromJson(json['payload']),
      );

  @override
  List<Object?> get props => [securityToken, payload];

  @override
  bool? get stringify => true;
}

MfaPayloadRequest _payloadFromJson(
  Map<String, dynamic>? json,
) {
  if (json == null || !json.containsKey('type')) {
    throw ArgumentError('Complete method is not supported');
  }

  final type = MfaMethod.values.byName(json['type']);

  switch (type) {
    case MfaMethod.pinBiometric:
      return MfaPinCodePayload.fromJson(json);
    case MfaMethod.otp:
      return MfaOtpPayload.fromJson(json);
    case MfaMethod.complete:
      throw ArgumentError('Complete method is not supported');
  }
}
