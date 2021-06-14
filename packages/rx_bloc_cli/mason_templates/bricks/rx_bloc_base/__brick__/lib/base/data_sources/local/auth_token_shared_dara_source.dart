// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shared_preferences/shared_preferences.dart';

import 'auth_token_data_source.dart';

/// Concrete implementation of AuthTokenDataSource using SharedPreferences.
/// Suitable for mobile and web.
/// Persist and get auth information to make it  available trough the app.
class AuthTokenSharedDataSource implements AuthTokenDataSource {

  /// Get stored access token
  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(DataSourceKeys.token);
  }

  /// Persist access token
  @override
  Future<bool> saveToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(DataSourceKeys.token, newToken);
  }

  /// Get stored refresh token
  @override
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(DataSourceKeys.refreshToken);
  }

  /// Persist new refresh token
  @override
  Future<bool> saveRefreshToken(String newRefreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(DataSourceKeys.refreshToken, newRefreshToken);
  }

  /// Delete all saved data
  @override
  Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
