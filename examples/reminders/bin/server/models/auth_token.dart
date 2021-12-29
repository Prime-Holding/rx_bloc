// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import '../utils/utilities.dart';

class AuthToken {
  AuthToken._(
      this.token,
      this.refreshToken,
      this.validUntil,
      );

  /// Generates a new auth token that's valid for one hour
  factory AuthToken.generateNew() => AuthToken._(
    generateRandomString(),
    generateRandomString(),
    DateTime.now().add(const Duration(hours: 1)),
  );

  /// The value of the access token
  final String token;

  /// The value of the refresh token
  final String refreshToken;

  /// The date until the access token is valid
  final DateTime validUntil;

  bool get isValid => DateTime.now().compareTo(validUntil) < 0;

  Map<String, Object?> toJson() => {
    'token': token,
    'refreshToken': refreshToken,
    'expires': validUntil.millisecondsSinceEpoch,
  };
}
