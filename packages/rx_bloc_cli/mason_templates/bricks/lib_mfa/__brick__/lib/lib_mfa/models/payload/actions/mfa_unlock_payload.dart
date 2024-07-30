import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../mfa_action.dart';
import '../mfa_payload_request.dart';

part 'mfa_unlock_payload.g.dart';

@JsonSerializable()
class MFAUnlockPayload extends MFAPayloadRequest with EquatableMixin {
  MFAUnlockPayload();

  @override
  String get type => MFAAction.unlock.name;

  factory MFAUnlockPayload.fromJson(Map<String, dynamic> json) =>
      _$MFAUnlockPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$MFAUnlockPayloadToJson(this);

  @override
  List<Object?> get props => [type];
}
