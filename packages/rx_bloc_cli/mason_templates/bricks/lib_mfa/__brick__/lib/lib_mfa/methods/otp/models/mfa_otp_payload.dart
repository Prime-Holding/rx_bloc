import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/mfa_method.dart';
import '../../../models/payload/mfa_payload_request.dart';

part 'mfa_otp_payload.g.dart';

@CopyWith()
@JsonSerializable()
class MfaOtpPayload extends MfaPayloadRequest with EquatableMixin {
  MfaOtpPayload({
    required this.code,
  });

  final String code;

  @override
  String get type => MfaMethod.otp.name;

  factory MfaOtpPayload.fromJson(Map<String, dynamic> json) =>
      _$MfaOtpPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$MfaOtpPayloadToJson(this);

  @override
  List<Object?> get props => [code, type];

  @override
  bool? get stringify => true;
}
