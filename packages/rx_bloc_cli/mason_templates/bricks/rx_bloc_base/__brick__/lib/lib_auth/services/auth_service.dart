{{> licence.dart }}

import '../models/auth_token_model.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  AuthService(this._authRepository);

  final AuthRepository _authRepository;

  /// Returns token if there is such one.
  Future<String?> getToken() => _authRepository.getToken();

  /// Checks if the user is authenticated.
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  /// Saves the token passed as [newToken] into persist storage.
  Future<void> saveToken(String newToken) =>
      _authRepository.saveToken(newToken);

  /// Returns refresh token if there is such one.
  Future<String?> getRefreshToken() => _authRepository.getRefreshToken();

  /// Saves the refresh token passed as [newRefreshToken] into persist storage.
  Future<void> saveRefreshToken(String newRefreshToken) =>
      _authRepository.saveRefreshToken(newRefreshToken);

  /// Deletes all saved tokens.
  Future<void> clearAuthData() => _authRepository.clearAuthData();

  /// Returns new token using the refresh token.
  ///
  /// If there isn't a refresh token it throws [StateError].
  /// See also [saveRefreshToken()] and [getRefeshToken()] for references.
  Future<AuthTokenModel> fetchNewToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw StateError('Refresh token not found');
    }

    // Fetch a new access token using refreshToken
    return _authRepository.fetchNewToken(refreshToken);
  }

  /// Checks the user credentials passed in [email], [password] and returns
  /// auth token.
  Future<AuthTokenModel> authenticate(
      {String? email, String? password, String? refreshToken}) =>
      _authRepository.authenticate(
        email: email,
        password: password,
        refreshToken: refreshToken,
      );

  /// Logs out the user
  Future<void> logout() => _authRepository.logout();
}
