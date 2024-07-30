import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import '../methods/otp/models/tfa_otp_payload.dart';
import '../methods/pin_biometric/models/tfa_pin_code_payload.dart';
import 'payload/tfa_payload_request.dart';
import 'tfa_method.dart';

part 'tfa_method_request.g.dart';

@CopyWith()
class TFAMethodRequest with EquatableMixin {
  TFAMethodRequest({
    required this.securityToken,
    required this.payload,
  });

  /// The security token used to authenticate the user and authorize the request.
  final String securityToken;

  /// The request body that contains the necessary user data to authenticate the user.
  final TFAPayloadRequest payload;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'securityToken': securityToken,
        'payload': payload.toJson(),
      };

  factory TFAMethodRequest.fromJson(Map<String, dynamic> json) =>
      TFAMethodRequest(
        securityToken: json['securityToken'],
        payload: _payloadFromJson(json['payload']),
      );

  @override
  List<Object?> get props => [securityToken, payload];

  @override
  bool? get stringify => true;
}

TFAPayloadRequest _payloadFromJson(
  Map<String, dynamic>? json,
) {
  if (json == null || !json.containsKey('type')) {
    throw ArgumentError('Complete method is not supported');
  }

  final type = TFAMethod.values.byName(json['type']);

  switch (type) {
    case TFAMethod.pinBiometric:
      return TFAPinCodePayload.fromJson(json);
    case TFAMethod.otp:
      return TFAOTPPayload.fromJson(json);
    case TFAMethod.complete:
      throw ArgumentError('Complete method is not supported');
  }
}
