import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/mfa_method.dart';
import '../../../models/payload/mfa_payload_request.dart';

part 'mfa_pin_code_payload.g.dart';

@CopyWith()
@JsonSerializable()
class MfaPinCodePayload extends MfaPayloadRequest with EquatableMixin {
  MfaPinCodePayload({required this.code});

  final String code;

  @override
  String get type => MfaMethod.pinBiometric.name;

  factory MfaPinCodePayload.fromJson(Map<String, dynamic> json) =>
      _$MfaPinCodePayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$MfaPinCodePayloadToJson(this);

  @override
  List<Object?> get props => [code];

  @override
  bool? get stringify => true;
}
