// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_sign_in/google_sign_in.dart';

class GoogleCredentialsModel {
  final String? displayName;
  final String email;
  final String id;
  final String? photoUrl;
  final String? serverAuthCode;

  GoogleCredentialsModel({
    this.displayName,
    required this.email,
    required this.id,
    this.photoUrl,
    this.serverAuthCode,
  });

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
