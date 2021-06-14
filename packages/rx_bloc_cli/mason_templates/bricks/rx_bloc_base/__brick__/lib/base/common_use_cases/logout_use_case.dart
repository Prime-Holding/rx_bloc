// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

{{#push_notifications}}
import 'package:firebase_messaging/firebase_messaging.dart';{{/push_notifications}}

import '../app/config/app_constants.dart';
import '../repositories/auth_repository.dart';
import '../repositories/push_notification_subscription_repository.dart';
import '../repositories/user_authentication_repository.dart';

class LogoutUseCase{
  LogoutUseCase(
    this._authRepository,
    this._userAuthRepository,
    this._pushSubscriptionRepository,
  );

  final AuthRepository _authRepository;
  final UserAuthRepository _userAuthRepository;
  final PushNotificationSubscriptionRepository _pushSubscriptionRepository;

  Future<void> execute() async {
    // TODO Add your logic for logging out here

    // Unsubscribe user push token
    try {
      {{#push_notifications}}
      final pushToken = await FirebaseMessaging.instance.getToken(vapidKey: webVapidKey);
      if (pushToken!=null) {
        await _pushSubscriptionRepository.unsubscribePush(pushToken);
      }
      {{/push_notifications}}{{^push_notifications}}
      final pushToken = '12345';
      await _pushSubscriptionRepository.unsubscribePush(pushToken);{{/push_notifications}}

    } catch (e) {
      print(e);
    }

    // Perform user logout
    try {
      await _userAuthRepository.logout();

      // Clear locally stored auth data
      await _authRepository.clearAuthData();
    } catch (e) {
      print(e);
    }

  }

}