{{> licence.dart }}

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleCredentialModel {
  AppleCredentialModel(
      {required this.authorizationCode,
        this.userIdentifier,
        this.firstName,
        this.lastName,
        this.email,
        this.identityToken});

  final String authorizationCode;
  final String? userIdentifier;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? identityToken;

  bool equals(AppleCredentialModel credentials) =>
      authorizationCode == credentials.authorizationCode &&
          userIdentifier == credentials.userIdentifier &&
          email == credentials.email;

  factory AppleCredentialModel.fromAppleId(
      AuthorizationCredentialAppleID credential) =>
      AppleCredentialModel(
          authorizationCode: credential.authorizationCode,
          email: credential.email,
          firstName: credential.givenName,
          lastName: credential.familyName,
          userIdentifier: credential.userIdentifier,
          identityToken: credential.identityToken);
}
