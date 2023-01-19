{{> licence.dart }}

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/auth_token_data_source.dart';
import '../data_sources/remote/auth_data_source.dart';
import '../data_sources/remote/refresh_token_data_source.dart';
import '../models/auth_token_model.dart';
import '../models/request_models/authenticate_user_request_model.dart';

class AuthRepository {
  AuthRepository(
    this._errorMapper,
    this._authTokenDataSource,
    this._authDataSource,
    this._refreshTokenDataSource,
  );

  final ErrorMapper _errorMapper;
  final AuthTokenDataSource _authTokenDataSource;
  final AuthDataSource _authDataSource;
  final RefreshTokenDataSource _refreshTokenDataSource;

  /// Get token string if there is one saved
  Future<String?> getToken() =>
      _errorMapper.execute(() => _authTokenDataSource.getToken());

  Future<bool> isAuthenticated() => _errorMapper.execute(() async {
        final token = await getToken();
        return token != null;
      });

  /// Persist new token string in secure storage
  Future<void> saveToken(String newToken) =>
      _errorMapper.execute(() => _authTokenDataSource.saveToken(newToken));

  /// Get refreshToken string if there is one saved
  Future<String?> getRefreshToken() =>
      _errorMapper.execute(() => _authTokenDataSource.getRefreshToken());

  /// Persist new refreshToken string in secure storage
  Future<void> saveRefreshToken(String newRefreshToken) => _errorMapper
      .execute(() => _authTokenDataSource.saveRefreshToken(newRefreshToken));

  /// Delete all saved tokens
  Future<void> clearAuthData() =>
      _errorMapper.execute(() => _authTokenDataSource.clear());

  /// Fetch a new access token using the current refresh token
  Future<AuthTokenModel> fetchNewToken() => _errorMapper.execute(() async {
        final refreshToken = await getRefreshToken();
        if (refreshToken == null) {
          throw StateError('Refresh token not found');
        }

        // Fetch a new access token using refreshToken
        return _refreshTokenDataSource.refresh(
          AuthUserRequestModel(refreshToken: refreshToken),
        );
      });

  Future<AuthTokenModel> authenticate(
          {String? email, String? password, String? refreshToken}) =>
      _errorMapper.execute(
        () => _authDataSource.authenticate(
          AuthUserRequestModel(
            username: email,
            password: password,
            refreshToken: refreshToken,
          ),
        ),
      );

  Future<void> logout() => _errorMapper.execute(() => _authDataSource.logout());
}
