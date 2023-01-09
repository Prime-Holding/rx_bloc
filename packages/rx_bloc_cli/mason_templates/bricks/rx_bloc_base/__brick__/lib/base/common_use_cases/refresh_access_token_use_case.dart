import '../repositories/auth_repository.dart';

/// Obtains a new access token from the remote API
/// using the current refresh token.
class RefreshAccessTokenUseCase {
  RefreshAccessTokenUseCase(this._authRepository);

  final AuthRepository _authRepository;

  /// Fetches a new access token from the remote API, stores it locally
  /// and then returns it.
  Future<String?> execute() async {
    final refreshToken = await _authRepository.getRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    final newToken = await _authRepository.fetchNewToken();

    if (newToken != null) {
      await _authRepository.saveToken(newToken);
    }

    return newToken;
  }
}
