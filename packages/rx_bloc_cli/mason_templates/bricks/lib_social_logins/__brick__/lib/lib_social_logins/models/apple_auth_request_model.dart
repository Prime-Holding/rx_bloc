{{> licence.dart }}

import 'package:json_annotation/json_annotation.dart';

import 'apple_credential_model.dart';

part 'apple_auth_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class AppleAuthRequestModel {
  AppleAuthRequestModel({
    required this.authorizationCode,
    this.userIdentifier,
    this.firstName,
    this.lastName,
    this.email,
    this.identityToken,
  });

  final String authorizationCode;
  final String? userIdentifier;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? identityToken;

  factory AppleAuthRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AppleAuthRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AppleAuthRequestModelToJson(this);

  factory AppleAuthRequestModel.fromAppleCredentials(
          AppleCredentialModel credentials) =>
      AppleAuthRequestModel(
        authorizationCode: credentials.authorizationCode,
        userIdentifier: credentials.userIdentifier,
        firstName: credentials.firstName,
        lastName: credentials.lastName,
        email: credentials.email,
        identityToken: credentials.identityToken,
      );
}
