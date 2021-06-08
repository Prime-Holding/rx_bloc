import '../repositories/auth_repository.dart';

class fetchNewAccessTokenUseCase {
  fetchNewAccessTokenUseCase(
    this._authRepository,
  );

  final AuthRepository _authRepository;

  Future<String?> execute() async {
    final refreshToken = await _authRepository.getRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    final newToken = await _authRepository.fetchNewToken();
    return newToken;
  }
}
