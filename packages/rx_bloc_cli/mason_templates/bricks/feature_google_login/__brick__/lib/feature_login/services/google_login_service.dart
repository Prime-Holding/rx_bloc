import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';
import '../../base/app/config/app_constants.dart';
import '../../base/repositories/push_notification_repository.dart';

import '../../lib_auth/repositories/auth_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../repositories/google_auth_repository.dart';

class GoogleLoginService {
  GoogleLoginService(
    this._googleAuthRepository,
    this._permissionsService,
    this._authRepository,
    this._pushSubscriptionRepository,
    this._googleSignIn,
  );
  final GoogleAuthRepository _googleAuthRepository;
  final PermissionsService _permissionsService;
  final AuthRepository _authRepository;
  final PushNotificationRepository _pushSubscriptionRepository;
  final GoogleSignIn _googleSignIn;

  Future<bool> googleLogin() async {
    try {
      // Initiate google login
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      //Get user's access token
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      //Authenticate user on the server
      final authToken = await _googleAuthRepository.googleAuth(
          email: googleUser?.email, token: googleAuth?.accessToken);

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
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
