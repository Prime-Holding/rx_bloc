{{> licence.dart}}
import 'package:google_sign_in/google_sign_in.dart';

class GoogleCredentialDataSource {
  Future<GoogleSignInAccount?> getUsersGoogleCredential() =>
      GoogleSignIn().signIn();
}