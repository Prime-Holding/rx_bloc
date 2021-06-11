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

class LoginUseCase {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<bool> execute({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) return false;
    print('LoginUseCase ::: Username: $username Password: $password');

    {{#push_notifications}}
    String? _token;
    try {
      _token = await FirebaseMessaging.instance.getToken(vapidKey: webVapidKey);
    } catch (e) {
      print(e.toString());
    } {{/push_notifications}}{{^push_notifications}}
    final _token = '1234567890'; // Fetch some kind of auth token and store it {{/push_notifications}}

    if (_token != null) {
      await _authRepository.saveToken(_token);
    }

    return true;
  }
}
