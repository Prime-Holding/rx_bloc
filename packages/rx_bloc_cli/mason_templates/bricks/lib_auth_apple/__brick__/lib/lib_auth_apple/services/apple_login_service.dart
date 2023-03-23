{{> licence.dart }}

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../assets.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_auth/models/auth_token_model.dart';
import '../../lib_auth/services/social_login_service.dart';
import '../models/apple_credentials_model.dart';
import '../repositories/apple_auth_repository.dart';

class AppleLoginService extends SocialLoginService {
  AppleLoginService(this._appleAuthRepository);

  final AppleAuthRepository _appleAuthRepository;

  @override
  Future<AuthTokenModel> getSocialAuthentication() async {
    final AuthorizationCredentialAppleID credentials =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credentials.authorizationCode.isEmpty) {
      throw GenericErrorModel(I18nErrorKeys.appleAuthenticationFailed);
    }

    AppleCredentialsModel appleCredentials = AppleCredentialsModel(
        authorizationCode: credentials.authorizationCode,
        email: credentials.email,
        firstName: credentials.givenName,
        lastName: credentials.familyName,
        userIdentifier: credentials.userIdentifier,
        identityToken: credentials.identityToken);

    return _appleAuthRepository.authenticateWithApple(
        credentials: appleCredentials);
  }
}
