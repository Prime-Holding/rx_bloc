import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../tfa_action.dart';
import '../tfa_payload_request.dart';

part 'tfa_unlock_payload.g.dart';

@JsonSerializable()
class TFAUnlockPayload extends TFAPayloadRequest with EquatableMixin {
  TFAUnlockPayload();

  @override
  String get type => TFAAction.unlock.name;

  factory TFAUnlockPayload.fromJson(Map<String, dynamic> json) =>
      _$TFAUnlockPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$TFAUnlockPayloadToJson(this);

  @override
  List<Object?> get props => [type];
}
