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
        if (error is SignInWithAppleAuthorizationException && // if user don't have saved apple id we have unknown error code so we will use message with error 1000
                error.message == CancelledErrorModel.cancelledAppleMessage ||
            error is SignInWithAppleAuthorizationException && // if user have saved apple id we can get error code
                error.code == AuthorizationErrorCode.canceled) {
          throw CancelledErrorModel();
        } else {
          throw Exception(error);
        }
      });
}
