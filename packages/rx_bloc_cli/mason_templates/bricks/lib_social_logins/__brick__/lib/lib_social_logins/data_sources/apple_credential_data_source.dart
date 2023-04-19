{{> licence.dart }}

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/cancelled_error_model.dart';

class AppleCredentialDataSource {
  Future<AuthorizationCredentialAppleID> getUsersAppleCredential() async {
    try {
      return await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        throw CancelledErrorModel();
      }

      rethrow;
    }
  }
}
