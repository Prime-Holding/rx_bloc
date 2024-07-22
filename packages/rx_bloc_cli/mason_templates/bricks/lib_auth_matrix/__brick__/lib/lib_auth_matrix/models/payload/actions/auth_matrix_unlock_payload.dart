import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../auth_matrix_action.dart';
import '../auth_matrix_payload_request.dart';

part 'auth_matrix_unlock_payload.g.dart';

@JsonSerializable()
class AuthMatrixUnlockPayload extends AuthMatrixPayloadRequest
    with EquatableMixin {
  AuthMatrixUnlockPayload();

  @override
  String get type => AuthMatrixAction.unlock.name;

  factory AuthMatrixUnlockPayload.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixUnlockPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() => _$AuthMatrixUnlockPayloadToJson(this);

  @override
  List<Object?> get props => [type];
}
