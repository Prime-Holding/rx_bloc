{{> licence.dart }}

import 'package:google_sign_in/google_sign_in.dart';

import '../models/cancelled_error_model.dart';

class GoogleCredentialDataSource {
  Future<GoogleSignInAccount> getUsersGoogleCredential() async {
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw CancelledErrorModel();
    }
    return googleUser;
  }
}
