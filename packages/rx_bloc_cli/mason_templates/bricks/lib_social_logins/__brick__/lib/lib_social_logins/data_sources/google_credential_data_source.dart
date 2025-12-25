{{> licence.dart }}

import 'package:google_sign_in/google_sign_in.dart';

import '../models/cancelled_error_model.dart';

class GoogleCredentialDataSource {
  Future<GoogleSignInAccount> getUsersGoogleCredential() =>
      GoogleSignIn.instance.authenticate();

  Future<GoogleSignInServerAuthorization?> getAuthServerCode(
    List<String> scopes,
  ) => GoogleSignIn.instance.authorizationClient.authorizeServer(scopes);
}

