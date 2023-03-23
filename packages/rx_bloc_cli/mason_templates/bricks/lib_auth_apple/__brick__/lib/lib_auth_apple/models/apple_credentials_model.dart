{{> licence.dart }}

class AppleCredentialsModel {
  AppleCredentialsModel(
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

  bool equals(AppleCredentialsModel credentials) =>
      authorizationCode == credentials.authorizationCode &&
      userIdentifier == credentials.userIdentifier &&
      email == credentials.email;
}
