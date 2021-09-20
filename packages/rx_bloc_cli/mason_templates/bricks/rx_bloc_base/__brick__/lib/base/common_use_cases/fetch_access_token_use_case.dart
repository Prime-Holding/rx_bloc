{{> licence.dart }}

import '../repositories/auth_repository.dart';

/// Returns access token, if is saved, by default.
class FetchAccessTokenUseCase {
  FetchAccessTokenUseCase(
    this._authRepository,
  );

  final AuthRepository _authRepository;

  /// If you want to get refresh token, you should set forceFetchNewToken to true
  Future<String?> execute({bool forceFetchNewToken = false}) async {
    if (!forceFetchNewToken) {
      final token = await _authRepository.getToken();
      if (token != null) {
        return token;
      }
    }
    final refreshToken = await _authRepository.getRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    final newToken = await _authRepository.fetchNewToken();
    return newToken;
  }
}
