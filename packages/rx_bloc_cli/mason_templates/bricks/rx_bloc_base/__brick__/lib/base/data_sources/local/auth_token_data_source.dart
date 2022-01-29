{{> licence.dart }}

/// Persist and get auth information in/from data source
/// so this information will be available trough the app
abstract class AuthTokenDataSource {
  /// Get stored access token
  Future<String?> getToken();

  /// Persist access token
  Future<void> saveToken(String newToken);

  /// Get stored refresh token
  Future<String?> getRefreshToken();

  /// Persist new refresh token
  Future<void> saveRefreshToken(String newRefreshToken);

  /// Delete all saved data
  Future<void> clear();
}

class DataSourceKeys {
  static const token = 'token';
  static const refreshToken = 'refreshToken';
}
