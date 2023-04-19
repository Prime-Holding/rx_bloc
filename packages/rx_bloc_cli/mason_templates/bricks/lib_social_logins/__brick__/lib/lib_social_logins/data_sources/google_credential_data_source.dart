{{> licence.dart }}

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/cancelled_error_model.dart';

class GoogleCredentialDataSource {
  Future<GoogleSignInAccount?> getUsersGoogleCredential() =>
      GoogleSignIn().signIn().catchError((error) {
        if (error is PlatformException &&
            error.code == CancelledErrorModel.googleUserCancelled) {
          throw CancelledErrorModel();
        } else {
          throw Exception(error);
        }
      });
}
