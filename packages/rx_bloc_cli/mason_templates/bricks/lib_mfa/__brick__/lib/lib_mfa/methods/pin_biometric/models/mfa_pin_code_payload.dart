import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/payload/mfa_payload_request.dart';
import '../../../models/mfa_method.dart';

part 'mfa_pin_code_payload.g.dart';

@CopyWith()
@JsonSerializable()
class MFAPinCodePayload extends MFAPayloadRequest with EquatableMixin {
  MFAPinCodePayload({required this.code});

  final String code;

  @override
  String get type => MFAMethod.pinBiometric.name;

  factory MFAPinCodePayload.fromJson(Map<String, dynamic> json) =>
      _$MFAPinCodePayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$MFAPinCodePayloadToJson(this);

  @override
  List<Object?> get props => [code];

  @override
  bool? get stringify => true;
}
