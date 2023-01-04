{{> licence.dart }}

import '../repositories/auth_repository.dart';

/// Returns access token from local storage or remote API.
class FetchAccessTokenUseCase {
  FetchAccessTokenUseCase(
    this._authRepository,
  );

  final AuthRepository _authRepository;

  /// Returns the access token obtained from local storage.
  /// If `forceFetchNewToken` is set to `true` then a new token is
  /// fetched from the server.
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
