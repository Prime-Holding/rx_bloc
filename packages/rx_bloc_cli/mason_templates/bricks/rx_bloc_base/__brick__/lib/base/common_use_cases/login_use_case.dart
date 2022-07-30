{{> licence.dart }}

import '../app/config/app_constants.dart';
import '../repositories/auth_repository.dart';
import '../repositories/push_notification_repository.dart';

class LoginUseCase {
  LoginUseCase(
    this._authRepository,
    this._pushSubscriptionRepository,
  );

  final AuthRepository _authRepository;
  final PushNotificationRepository _pushSubscriptionRepository;

  Future<bool> execute({
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
      print(e);
    }

    return true;
  }
}
