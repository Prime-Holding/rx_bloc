{{> licence.dart }}

import '../models/auth_token_model.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  AuthService(this._authRepository);

  final AuthRepository _authRepository;

  Future<String?> getToken() => _authRepository.getToken();

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> saveToken(String newToken) =>
      _authRepository.saveToken(newToken);

  Future<String?> getRefreshToken() => _authRepository.getRefreshToken();

  Future<void> saveRefreshToken(String newRefreshToken) =>
      _authRepository.saveRefreshToken(newRefreshToken);

  Future<void> clearAuthData() => _authRepository.clearAuthData();

  Future<AuthTokenModel> fetchNewToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw StateError('Refresh token not found');
    }

    // Fetch a new access token using refreshToken
    return _authRepository.fetchNewToken(refreshToken);
  }

  Future<AuthTokenModel> authenticate(
      {String? email, String? password, String? refreshToken}) =>
      _authRepository.authenticate(
        email: email,
        password: password,
        refreshToken: refreshToken,
      );

  Future<void> logout() => _authRepository.logout();
}
