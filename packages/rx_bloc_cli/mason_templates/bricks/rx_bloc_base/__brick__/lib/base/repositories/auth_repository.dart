// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../data_sources/local/auth_token_data_source.dart';

class AuthRepository {
  AuthRepository(this._authDataSource);

  final AuthTokenDataSource _authDataSource;

  // Get token string if there is saved
  Future<String?> getToken() => _authDataSource.getToken();

  // Persist new token string in secure storage
  Future<void> saveToken(String newToken) =>
      _authDataSource.saveToken(newToken);

  // Get refreshToken string if there is saved
  Future<String?> getRefreshToken() => _authDataSource.getRefreshToken();

  // Persist new refreshToken string in secure storage
  Future<void> saveRefreshToken(String newRefreshToken) =>
      _authDataSource.saveRefreshToken(newRefreshToken);

  // Delete all saved tokens
  Future<void> clearAuthData() => _authDataSource.clear();

// Fetch new access token
  Future<String?> fetchNewToken() async {
    final refreshToken = await getRefreshToken();
    try {
      // TODO try to fetch new access token using refreshToken and save it
      // https://flutteragency.com/refresh-token-using-interceptor-in-dio/
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
