import '../repositories/auth_repository.dart';

/// Returns access token from local storage.
class FetchAccessTokenUseCase {
  FetchAccessTokenUseCase(this._authRepository);

  final AuthRepository _authRepository;

  /// Returns the access token obtained from local storage.
  Future<String?> execute() async {
    final token = await _authRepository.getToken();
    return token;
  }
}
