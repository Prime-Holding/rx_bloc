// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';{{/push_notifications}}

import '../../base/repositories/auth_repository.dart';
import '../app/config/app_constants.dart';
import '../repositories/push_notification_subscription_repository.dart';
import '../repositories/user_authentication_repository.dart';

class LoginUseCase {
  LoginUseCase(
    this._authRepository,
    this._userAuthRepository,
    this._pushSubscriptionRepository,
  );

  final AuthRepository _authRepository;
  final UserAuthRepository _userAuthRepository;
  final PushNotificationSubscriptionRepository _pushSubscriptionRepository;

  Future<bool> execute({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) return false;

    // Perform user login
    try {
      final authToken = await _userAuthRepository.authenticate(
          email: username, password: password);

      // Save response tokens
      await _authRepository.saveToken(authToken.token);
      await _authRepository.saveRefreshToken(authToken.refreshToken);
    } catch (e) {
      print(e);
      return false;
    }

    // Subscribe user push token
    try {
      {{#push_notifications}}
      final pushToken = await FirebaseMessaging.instance.getToken(vapidKey: webVapidKey);
      if (pushToken!=null) {
        await _pushSubscriptionRepository.subscribePush(pushToken);
      }
      {{/push_notifications}}{{^push_notifications}}
      final pushToken = '12345';
      await _pushSubscriptionRepository.subscribePush(pushToken);{{/push_notifications}}

    } catch (e) {
      print(e);
    }

    return true;
  }
}
