{{> licence.dart }}

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'payload/response/tfa_last_login_payload_response.dart';
import 'payload/tfa_payload_response.dart';
import 'tfa_method.dart';

part 'tfa_response.g.dart';

@JsonSerializable()
@CopyWith()
class TFAResponse with EquatableMixin {
  TFAResponse({
    required this.securityToken,
    required this.authMethod,
    required this.transactionId,
    required this.documentIds,
    required this.expires,
    this.payload,
  });

  /// The draft document ids created by the initial TFA request.
  ///
  /// Once the user completes all authentication methods successfully, the documents will be marked as signed.
  final List<int> documentIds;

  /// The security token, which ensures the chain of TFA requests.
  ///
  /// It's used in the following payload requests to ensure the chain of requests.
  @JsonKey(defaultValue: '')
  final String securityToken;

  /// The expiration date of the TFA request.
  @JsonKey(defaultValue: '')
  final String expires;

  /// The TFA method to be used for the following request.
  final TFAMethod authMethod;

  /// The unique TFA transaction id.
  ///
  /// It's used in the following payload requests to ensure the chain of requests.
  final String transactionId;

  /// Dynamic additional data to be received from the API along with the required
  /// response properties. Create custom TFAPayloadResponse implementation
  /// for each case.
  @JsonKey(fromJson: _payloadFromJson, toJson: _payloadToJson)
  final TFAPayloadResponse? payload;

  factory TFAResponse.fromJson(Map<String, dynamic> json) =>
      _$TFAResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TFAResponseToJson(this);

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

TFAPayloadResponse? _payloadFromJson(
  Map<String, dynamic>? json,
) {
  if (json == null || !json.containsKey('type')) {
    return null;
  }

  try {
    final type = TFAPayloadResponseType.values.byName(json['type']);

    return switch (type) {
      (TFAPayloadResponseType.lastLogin) =>
        TFALastLoginPayloadResponse.fromJson(json),
    };
  } on ArgumentError catch (_) {
    return null;
  }
}

Map<String, dynamic>? _payloadToJson(TFAPayloadResponse? payload) =>
    payload?.toJson();
