{{> licence.dart }}

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'auth_matrix_method.dart';

import 'payload/auth_matrix_payload_response.dart';
import 'payload/response/auth_matrix_last_login_payload_response.dart';

part 'auth_matrix_response.g.dart';

@JsonSerializable()
@CopyWith()
class AuthMatrixResponse with EquatableMixin {
  AuthMatrixResponse({
    required this.securityToken,
    required this.authMethod,
    required this.transactionId,
    required this.documentIds,
    required this.expires,
    this.payload,
  });

  /// The draft document ids created by the initial auth matrix request.
  ///
  /// Once the user completes all authentication methods successfully, the documents will be marked as signed.
  final List<int> documentIds;

  /// The security token, which ensures the chain of auth matrix requests.
  ///
  /// It's used in the following payload requests to ensure the chain of requests.
  @JsonKey(defaultValue: '')
  final String securityToken;

  /// The expiration date of the auth matrix request.
  @JsonKey(defaultValue: '')
  final String expires;

  /// The auth matrix method to be used for the following request.
  final AuthMatrixMethod authMethod;

  /// The unique auth matrix transaction id.
  ///
  /// It's used in the following payload requests to ensure the chain of requests.
  final String transactionId;

  /// Dynamic additional data to be received from the API along with the required
  /// response properties. Create custom AuthMatrixPayloadResponse implementation
  /// for each case.
  @JsonKey(fromJson: _payloadFromJson, toJson: _payloadToJson)
  final AuthMatrixPayloadResponse? payload;

  factory AuthMatrixResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthMatrixResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMatrixResponseToJson(this);

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

AuthMatrixPayloadResponse? _payloadFromJson(
  Map<String, dynamic>? json,
) {
  if (json == null || !json.containsKey('type')) {
    return null;
  }

  try {
    final type = AuthMatrixPayloadResponseType.values.byName(json['type']);

    return switch (type) {
      (AuthMatrixPayloadResponseType.lastLogin) =>
        AuthMatrixLastLoginPayloadResponse.fromJson(json),
    };
  } on ArgumentError catch (_) {
    return null;
  }
}

Map<String, dynamic>? _payloadToJson(AuthMatrixPayloadResponse? payload) =>
    payload?.toJson();
