{{> licence.dart }}

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mfa_method.dart';
import 'payload/mfa_payload_response.dart';
import 'payload/response/mfa_last_login_payload_response.dart';

part 'mfa_response.g.dart';

@JsonSerializable()
@CopyWith()
class MfaResponse with EquatableMixin {
  MfaResponse({
    required this.securityToken,
    required this.authMethod,
    required this.transactionId,
    required this.documentIds,
    required this.expires,
    this.payload,
  });

  /// The draft document ids created by the initial MFA request.
  ///
  /// Once the user completes all authentication methods successfully, the documents will be marked as signed.
  final List<int> documentIds;

  /// The security token, which ensures the chain of MFA requests.
  ///
  /// It's used in the following payload requests to ensure the chain of requests.
  @JsonKey(defaultValue: '')
  final String securityToken;

  /// The expiration date of the MFA request.
  @JsonKey(defaultValue: '')
  final String expires;

  /// The MFA method to be used for the following request.
  final MfaMethod authMethod;

  /// The unique MFA transaction id.
  ///
  /// It's used in the following payload requests to ensure the chain of requests.
  final String transactionId;

  /// Dynamic additional data to be received from the API along with the required
  /// response properties. Create custom MfaPayloadResponse implementation
  /// for each case.
  @JsonKey(fromJson: _payloadFromJson, toJson: _payloadToJson)
  final MfaPayloadResponse? payload;

  factory MfaResponse.fromJson(Map<String, dynamic> json) =>
      _$MfaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MfaResponseToJson(this);

  @override
  List<Object?> get props => [
        securityToken,
        authMethod,
        transactionId,
        documentIds,
        expires,
        payload,
      ];

  @override
  bool? get stringify => true;
}

MfaPayloadResponse? _payloadFromJson(
  Map<String, dynamic>? json,
) {
  if (json == null || !json.containsKey('type')) {
    return null;
  }

  try {
    final type = MfaPayloadResponseType.values.byName(json['type']);

    return switch (type) {
      (MfaPayloadResponseType.lastLogin) =>
        MfaLastLoginPayloadResponse.fromJson(json),
    };
  } on ArgumentError catch (_) {
    return null;
  }
}

Map<String, dynamic>? _payloadToJson(MfaPayloadResponse? payload) =>
    payload?.toJson();
