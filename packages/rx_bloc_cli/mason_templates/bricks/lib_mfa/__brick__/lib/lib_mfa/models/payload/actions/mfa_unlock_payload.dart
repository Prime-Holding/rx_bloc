import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../mfa_action.dart';
import '../mfa_payload_request.dart';

part 'mfa_unlock_payload.g.dart';

@JsonSerializable()
class MfaUnlockPayload extends MfaPayloadRequest with EquatableMixin {
  MfaUnlockPayload();

  @override
  String get type => MfaAction.unlock.name;

  factory MfaUnlockPayload.fromJson(Map<String, dynamic> json) =>
      _$MfaUnlockPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$MfaUnlockPayloadToJson(this);

  @override
  List<Object?> get props => [type];
}
