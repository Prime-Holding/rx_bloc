import 'dart:developer';

import '../../base/app/config/app_constants.dart';
import '../../base/repositories/push_notification_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../repositories/auth_repository.dart';

class UserAccountService {
  UserAccountService(
    this._authRepository,
    this._pushSubscriptionRepository,
    this._permissionsService,
  );

  final AuthRepository _authRepository;
  final PushNotificationRepository _pushSubscriptionRepository;
  final PermissionsService _permissionsService;

  /// Checks the user credentials passed in [username] and [password].
  ///
  /// After successful login saves the auth `token` and `refresh token` to
  /// persistent storage and loads the user permissions.
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) return false;

    final authToken = await _authRepository.authenticate(
      email: username,
      password: password,
    );

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
  }

  /// This method logs out the user and delete all stored auth token data.
  ///
  /// After logging out the user it reloads all permissions.
  Future<bool> logout() async {
    // Unsubscribe user push token
    try {
      final pushToken =
          await _pushSubscriptionRepository.getToken(vapidKey: webVapidKey);
      if (pushToken != null) {
        await _pushSubscriptionRepository.unsubscribe(pushToken);
      }
    } catch (e) {
      log(e.toString());
    }

    // Perform user logout
    try {
      await _authRepository.logout();
    } catch (e) {
      log(e.toString());
    }

    // Reload user permissions
    try {
      await _permissionsService.load();
    } catch (e) {
      log(e.toString());
    }

    // Clear locally stored auth data
    await _authRepository.clearAuthData();

    return true;
  }
}
