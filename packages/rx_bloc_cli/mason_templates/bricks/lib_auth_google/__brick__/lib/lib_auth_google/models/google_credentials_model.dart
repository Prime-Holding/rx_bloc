{{> licence.dart }}

import 'package:google_sign_in/google_sign_in.dart';

class GoogleCredentialsModel {
  GoogleCredentialsModel({
    this.displayName,
    required this.email,
    required this.id,
    this.photoUrl,
    this.serverAuthCode,
  });
  
  final String? displayName;
  final String email;
  final String id;
  final String? photoUrl;
  final String? serverAuthCode;

  bool equals(GoogleCredentialsModel credentials) =>
      displayName == credentials.displayName &&
      email == credentials.email &&
      id == credentials.id &&
      photoUrl == credentials.photoUrl &&
      serverAuthCode == credentials.serverAuthCode;

  factory GoogleCredentialsModel.fromGoogleCredentials(
          GoogleSignInAccount credential) =>
      GoogleCredentialsModel(
        displayName: credential.displayName,
        email: credential.email,
        id: credential.id,
        photoUrl: credential.photoUrl,
        serverAuthCode: credential.serverAuthCode,
      );
}
