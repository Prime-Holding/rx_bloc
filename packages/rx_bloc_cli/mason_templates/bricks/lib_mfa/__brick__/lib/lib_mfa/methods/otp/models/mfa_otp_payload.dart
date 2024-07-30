import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/payload/mfa_payload_request.dart';
import '../../../models/mfa_method.dart';

part 'mfa_otp_payload.g.dart';

@CopyWith()
@JsonSerializable()
class MFAOTPPayload extends MFAPayloadRequest with EquatableMixin {
  MFAOTPPayload({
    required this.code,
  });

  final String code;

  @override
  String get type => MFAMethod.otp.name;

  factory MFAOTPPayload.fromJson(Map<String, dynamic> json) =>
      _$MFAOTPPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$MFAOTPPayloadToJson(this);

  @override
  List<Object?> get props => [code, type];

  @override
  bool? get stringify => true;
}
