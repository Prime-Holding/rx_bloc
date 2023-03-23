{{> licence.dart }}

import 'dart:developer';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../assets.dart';
import '../../base/app/config/app_constants.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/repositories/push_notification_repository.dart';
import '../../lib_auth/repositories/auth_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../models/apple_credentials_model.dart';
import '../repositories/apple_auth_repository.dart';

class AppleLoginService {
  AppleLoginService(
    this._authRepository,
    this._permissionsService,
    this._pushSubscriptionRepository,
    this._appleAuthRepository,
  );

  final AuthRepository _authRepository;
  final PushNotificationRepository _pushSubscriptionRepository;
  final PermissionsService _permissionsService;
  final AppleAuthRepository _appleAuthRepository;

  Future<void> loginWithApple() async {
    final AuthorizationCredentialAppleID credentials =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credentials.authorizationCode.isEmpty) {
      throw GenericErrorModel(I18nErrorKeys.wrongAppleCredentials);
    }

    AppleCredentialsModel appleCredentials = AppleCredentialsModel(
        authorizationCode: credentials.authorizationCode,
        email: credentials.email,
        firstName: credentials.givenName,
        lastName: credentials.familyName,
        userIdentifier: credentials.userIdentifier,
        identityToken: credentials.identityToken);

    final authToken = await _appleAuthRepository.authenticateWithApple(
        credentials: appleCredentials);

// Save response tokens
    await _authRepository.saveToken(authToken.token);
    await _authRepository.saveRefreshToken(authToken.refreshToken);

// Subscribe user push token
    try {
      final pushToken =
          await _pushSubscriptionRepository.getToken(vapidKey: webVapidKey);
      if (pushToken != null) {
        await _pushSubscriptionRepository.subscribe(pushToken);
      }
    } catch (e) {
      log(e.toString());
    }

// Load permissions
    try {
      await _permissionsService.load();
    } catch (e) {
      log(e.toString());
    }
  }
}
