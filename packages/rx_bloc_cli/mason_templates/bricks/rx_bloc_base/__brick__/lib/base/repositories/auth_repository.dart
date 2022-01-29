{{> licence.dart }}

import '../data_sources/local/auth_token_data_source.dart';
import '../data_sources/remote/auth_data_source.dart';
import '../models/auth_token_model.dart';
import '../models/request_models/authenticate_user_request_model.dart';

class AuthRepository {
  AuthRepository(
      {required AuthTokenDataSource authTokenDataSource,
      required AuthDataSource authDataSource})
      : _authDataSource = authDataSource,
        _authTokenDataSource = authTokenDataSource;

  final AuthTokenDataSource _authTokenDataSource;
  final AuthDataSource _authDataSource;

  // Get token string if there is saved
  Future<String?> getToken() => _authTokenDataSource.getToken();

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // Persist new token string in secure storage
  Future<void> saveToken(String newToken) =>
      _authTokenDataSource.saveToken(newToken);

  // Get refreshToken string if there is saved
  Future<String?> getRefreshToken() => _authTokenDataSource.getRefreshToken();

  // Persist new refreshToken string in secure storage
  Future<void> saveRefreshToken(String newRefreshToken) =>
      _authTokenDataSource.saveRefreshToken(newRefreshToken);

  // Delete all saved tokens
  Future<void> clearAuthData() => _authTokenDataSource.clear();

// Fetch new access token
  Future<String?> fetchNewToken() async {
    // ignore: unused_local_variable
    final refreshToken = await getRefreshToken();
    try {
      // TODO: Try to fetch new access token using refreshToken and save it
      // https://flutteragency.com/refresh-token-using-interceptor-in-dio/
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AuthTokenModel> authenticate(
          {String? email, String? password, String? refreshToken}) =>
      _authDataSource.authenticate(AuthUserRequestModel(
          username: email, password: password, refreshToken: refreshToken));

  Future<void> logout() => _authDataSource.logout();
}
