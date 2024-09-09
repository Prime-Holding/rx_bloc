import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../mfa_payload_response.dart';
part 'mfa_last_login_payload_response.g.dart';

@JsonSerializable()
class MfaLastLoginPayloadResponse extends MfaPayloadResponse
    with EquatableMixin {
  final DateTime lastLogin;

  MfaLastLoginPayloadResponse({required this.lastLogin});

  factory MfaLastLoginPayloadResponse.fromJson(Map<String, dynamic> json) =>
      _$MfaLastLoginPayloadResponseFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() =>
      _$MfaLastLoginPayloadResponseToJson(this);

  @override
  MfaPayloadResponseType get type => MfaPayloadResponseType.lastLogin;

  @override
  List<Object?> get props => [type, lastLogin];

  @override
  bool? get stringify => true;
}
