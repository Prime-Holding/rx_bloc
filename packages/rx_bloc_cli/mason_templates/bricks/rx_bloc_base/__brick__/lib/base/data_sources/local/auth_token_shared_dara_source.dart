{{> licence.dart }}

import '../local/shared_preferences_instance.dart';

import 'auth_token_data_source.dart';

/// Concrete implementation of AuthTokenDataSource using SharedPreferences.
/// Suitable for mobile and web.
/// Persist and get auth information to make it  available trough the app.
class AuthTokenSharedDataSource implements AuthTokenDataSource {
  AuthTokenSharedDataSource(this._storage);

  final SharedPreferencesInstance _storage;

  /// Get stored access token
  @override
  Future<String?> getToken() => _storage.getString(DataSourceKeys.token);

  /// Persist access token
  @override
  Future<bool> saveToken(String newToken) =>
      _storage.setString(DataSourceKeys.token, newToken);

  /// Get stored refresh token
  @override
  Future<String?> getRefreshToken() =>
      _storage.getString(DataSourceKeys.refreshToken);

  /// Persist new refresh token
  @override
  Future<bool> saveRefreshToken(String newRefreshToken) =>
      _storage.setString(DataSourceKeys.refreshToken, newRefreshToken);

  /// Delete all saved data
  @override
  Future<bool> clear() async => _storage.clear();
}
