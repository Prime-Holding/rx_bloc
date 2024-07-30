import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import '../methods/otp/models/mfa_otp_payload.dart';
import '../methods/pin_biometric/models/mfa_pin_code_payload.dart';
import 'payload/mfa_payload_request.dart';
import 'mfa_method.dart';

part 'mfa_method_request.g.dart';

@CopyWith()
class MFAMethodRequest with EquatableMixin {
  MFAMethodRequest({
    required this.securityToken,
    required this.payload,
  });

  /// The security token used to authenticate the user and authorize the request.
  final String securityToken;

  /// The request body that contains the necessary user data to authenticate the user.
  final MFAPayloadRequest payload;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'securityToken': securityToken,
        'payload': payload.toJson(),
      };

  factory MFAMethodRequest.fromJson(Map<String, dynamic> json) =>
      MFAMethodRequest(
        securityToken: json['securityToken'],
        payload: _payloadFromJson(json['payload']),
      );

  @override
  List<Object?> get props => [securityToken, payload];

  @override
  bool? get stringify => true;
}

MFAPayloadRequest _payloadFromJson(
  Map<String, dynamic>? json,
) {
  if (json == null || !json.containsKey('type')) {
    throw ArgumentError('Complete method is not supported');
  }

  final type = MFAMethod.values.byName(json['type']);

  switch (type) {
    case MFAMethod.pinBiometric:
      return MFAPinCodePayload.fromJson(json);
    case MFAMethod.otp:
      return MFAOTPPayload.fromJson(json);
    case MFAMethod.complete:
      throw ArgumentError('Complete method is not supported');
  }
}
