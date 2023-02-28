{{> licence.dart }}

import 'package:jwt_decoder/jwt_decoder.dart';

import 'auth_service.dart';

class AccessTokenService {
  AccessTokenService(this._authService);

  final AuthService _authService;

  /// Returns the access token obtained from local storage.
  Future<String?> getAccessToken() async {
    return _authService.getToken();
  }

  /// Fetches a new access token from the remote API, stores it locally
  /// and then returns it.
  Future<String> refreshAccessToken() async {
    final newToken = await _authService.fetchNewToken();
    await _authService.saveToken(newToken.token);
    await _authService.saveRefreshToken(newToken.refreshToken);

    return newToken.token;
  }

  /// Returns `true` if the given access token is expired.
  bool isExpired(String accessToken) {
    return JwtDecoder.isExpired(accessToken);
  }
}
