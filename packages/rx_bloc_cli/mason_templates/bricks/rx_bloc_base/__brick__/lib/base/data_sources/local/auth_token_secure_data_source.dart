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
  AuthTokenSecureDataSource(this._storage);

  final FlutterSecureStorage _storage;

  /// Get stored access token
  @override
  Future<String?> getToken() => _storage.read(key: DataSourceKeys.token);

  /// Persist access token
  @override
  Future<void> saveToken(String newToken) =>
      _storage.write(key: DataSourceKeys.token, value: newToken);

  /// Get stored refresh token
  @override
  Future<String?> getRefreshToken() =>
      _storage.read(key: DataSourceKeys.refreshToken);

  /// Persist new refresh token
  @override
  Future<void> saveRefreshToken(String newRefreshToken) =>
      _storage.write(key: DataSourceKeys.refreshToken, value: newRefreshToken);

  /// Delete all saved data
  @override
  Future<void> clear() => _storage.deleteAll();
}
