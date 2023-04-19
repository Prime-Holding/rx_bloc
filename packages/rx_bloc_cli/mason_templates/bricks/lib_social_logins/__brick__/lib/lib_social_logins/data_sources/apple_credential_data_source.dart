{{> licence.dart }}

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/cancelled_error_model.dart';

class AppleCredentialDataSource {
  Future<AuthorizationCredentialAppleID> getUsersAppleCredential() =>
      SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ).onError((error, stackTrace) {
        throw CancelledErrorModel();
      });
}
