import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/payload/tfa_payload_request.dart';
import '../../../models/tfa_method.dart';

part 'tfa_otp_payload.g.dart';

@CopyWith()
@JsonSerializable()
class TFAOTPPayload extends TFAPayloadRequest with EquatableMixin {
  TFAOTPPayload({
    required this.code,
  });

  final String code;

  @override
  String get type => TFAMethod.otp.name;

  factory TFAOTPPayload.fromJson(Map<String, dynamic> json) =>
      _$TFAOTPPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$TFAOTPPayloadToJson(this);

  @override
  List<Object?> get props => [code, type];

  @override
  bool? get stringify => true;
}
