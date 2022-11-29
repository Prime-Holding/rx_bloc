{{> licence.dart }}

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/auth_token_data_source.dart';
import '../data_sources/remote/auth_data_source.dart';
import '../models/auth_token_model.dart';
import '../models/request_models/authenticate_user_request_model.dart';

class AuthRepository {
  AuthRepository(
    this._errorMapper,
    this._authTokenDataSource,
    this._authDataSource,
  );

  final ErrorMapper _errorMapper;
  final AuthTokenDataSource _authTokenDataSource;
  final AuthDataSource _authDataSource;

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

  /// Fetch new access token
  Future<String?> fetchNewToken() => _errorMapper.execute(() async {
        // ignore: unused_local_variable
        final refreshToken = await getRefreshToken();
        // TODO: Try to fetch new access token using refreshToken and save it
        // https://flutteragency.com/refresh-token-using-interceptor-in-dio/
        return '';
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
