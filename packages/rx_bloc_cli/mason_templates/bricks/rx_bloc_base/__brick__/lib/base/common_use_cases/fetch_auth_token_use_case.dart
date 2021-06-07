import '../repositories/auth_repository.dart';

class FetchAuthTokenUseCase {
  FetchAuthTokenUseCase(
    this._authRepository,
  );

  final AuthRepository _authRepository;

  Future<String?> fetchNewAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    final newToken = await _authRepository.fetchNewToken();
    return newToken;
  }

  Future<String?> getRefreshToken() async => _authRepository.getRefreshToken();
}
