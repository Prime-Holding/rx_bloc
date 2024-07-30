import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/payload/tfa_payload_request.dart';
import '../../../models/tfa_method.dart';

part 'tfa_pin_code_payload.g.dart';

@CopyWith()
@JsonSerializable()
class TFAPinCodePayload extends TFAPayloadRequest with EquatableMixin {
  TFAPinCodePayload({required this.code});

  final String code;

  @override
  String get type => TFAMethod.pinBiometric.name;

  factory TFAPinCodePayload.fromJson(Map<String, dynamic> json) =>
      _$TFAPinCodePayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$TFAPinCodePayloadToJson(this);

  @override
  List<Object?> get props => [code];

  @override
  bool? get stringify => true;
}
