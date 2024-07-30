import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../tfa_payload_response.dart';
part 'tfa_last_login_payload_response.g.dart';

@JsonSerializable()
class TFALastLoginPayloadResponse extends TFAPayloadResponse
    with EquatableMixin {
  final DateTime lastLogin;

  TFALastLoginPayloadResponse({required this.lastLogin});

  factory TFALastLoginPayloadResponse.fromJson(Map<String, dynamic> json) =>
      _$TFALastLoginPayloadResponseFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() =>
      _$TFALastLoginPayloadResponseToJson(this);

  @override
  TFAPayloadResponseType get type => TFAPayloadResponseType.lastLogin;

  @override
  List<Object?> get props => [type, lastLogin];

  @override
  bool? get stringify => true;
}
