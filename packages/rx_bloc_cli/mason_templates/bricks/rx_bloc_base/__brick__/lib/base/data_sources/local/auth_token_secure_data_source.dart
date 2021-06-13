// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_token_data_source.dart';

/// Concrete implementation of AuthTokenDataSource using FlutterSecureStorage.
/// Suitable for mobile.
/// Persist and get auth information to make it  available trough the app.
class AuthTokenSecureDataSource implements AuthTokenDataSource {

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Get stored access token
  Future<String?> getToken() => _storage.read(key: SecureStorageKeys.token);

  /// Persist access token
  Future<void> saveToken(String newToken) =>
      _storage.write(key: SecureStorageKeys.token, value: newToken);

  /// Get stored refresh token
  Future<String?> getRefreshToken() =>
      _storage.read(key: SecureStorageKeys.refreshToken);

  /// Persist new refresh token
  Future<void> saveRefreshToken(String newRefreshToken) => _storage.write(
      key: SecureStorageKeys.refreshToken, value: newRefreshToken);

  /// Delete all saved data
  Future<void> clear() => _storage.deleteAll();
}