{{> licence.dart }}

import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleCredentialsModel extends Equatable {
  final String? displayName;
  final String email;
  final String id;
  final String? photoUrl;
  final String? serverAuthCode;

  const GoogleCredentialsModel({
    this.displayName,
    required this.email,
    required this.id,
    this.photoUrl,
    this.serverAuthCode,
  });

  factory GoogleCredentialsModel.fromGoogleCredentials(
    GoogleSignInAccount credential,
    String? serverAuthCode,
  ) => GoogleCredentialsModel(
    displayName: credential.displayName,
    email: credential.email,
    id: credential.id,
    photoUrl: credential.photoUrl,
    serverAuthCode: serverAuthCode,
  );

  @override
  List<Object?> get props => [displayName, email, id, photoUrl, serverAuthCode];
}
