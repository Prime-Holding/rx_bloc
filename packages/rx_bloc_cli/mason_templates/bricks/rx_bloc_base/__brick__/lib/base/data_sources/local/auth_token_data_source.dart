// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persist and get auth information in/from FlutterSecureStorage
/// so this information will be available trough the app and protected
class AuthTokenDataSource {
  AuthTokenDataSource(this._storage);

  final FlutterSecureStorage _storage;

  /// Get stored access token
  Future<String?> getToken() => _storage.read(key: SecureStorageKeys._token);

  /// Persist access token
  Future<void> saveToken(String newToken) =>
      _storage.write(key: SecureStorageKeys._token, value: newToken);

  /// Get stored refresh token
  Future<String?> getRefreshToken() =>
      _storage.read(key: SecureStorageKeys._refreshToken);

  /// Persist new refresh token
  Future<void> saveRefreshToken(String newRefreshToken) => _storage.write(
      key: SecureStorageKeys._refreshToken, value: newRefreshToken);

  /// Delete all saved data
  Future<void> clear() => _storage.deleteAll();
}

class SecureStorageKeys {
  static const _token = 'token';
  static const _refreshToken = 'refreshToken';
}
