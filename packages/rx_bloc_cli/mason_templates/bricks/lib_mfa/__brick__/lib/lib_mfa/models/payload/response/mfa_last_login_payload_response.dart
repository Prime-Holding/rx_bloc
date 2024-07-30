import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../mfa_payload_response.dart';
part 'mfa_last_login_payload_response.g.dart';

@JsonSerializable()
class MFALastLoginPayloadResponse extends MFAPayloadResponse
    with EquatableMixin {
  final DateTime lastLogin;

  MFALastLoginPayloadResponse({required this.lastLogin});

  factory MFALastLoginPayloadResponse.fromJson(Map<String, dynamic> json) =>
      _$MFALastLoginPayloadResponseFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() =>
      _$MFALastLoginPayloadResponseToJson(this);

  @override
  MFAPayloadResponseType get type => MFAPayloadResponseType.lastLogin;

  @override
  List<Object?> get props => [type, lastLogin];

  @override
  bool? get stringify => true;
}
