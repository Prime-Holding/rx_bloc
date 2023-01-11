import 'package:jwt_decoder/jwt_decoder.dart';

import '../repositories/auth_repository.dart';

class AccessTokenService {
  AccessTokenService(this._authRepository);

  final AuthRepository _authRepository;

  /// Returns the access token obtained from local storage.
  Future<String?> getAccessToken() async {
    return _authRepository.getToken();
  }

  /// Fetches a new access token from the remote API, stores it locally
  /// and then returns it.
  Future<String?> refreshAccessToken() async {
    final newToken = await _authRepository.fetchNewToken();
    if (newToken != null) {
      await _authRepository.saveToken(newToken);
    }

    return newToken;
  }

  /// Returns `true` if the given access token is expired.
  bool isExpired(String accessToken) {
    return JwtDecoder.isExpired(accessToken);
  }
}
