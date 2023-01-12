import 'dart:developer';

import '../app/config/app_constants.dart';
import '../repositories/auth_repository.dart';
import '../repositories/push_notification_repository.dart';

class UserAccountService {
  UserAccountService(
    this._authRepository,
    this._pushSubscriptionRepository,
  );

  final AuthRepository _authRepository;
  final PushNotificationRepository _pushSubscriptionRepository;

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

    return true;
  }

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
    await _authRepository.logout();

    // Clear locally stored auth data
    await _authRepository.clearAuthData();

    return true;
  }
}
