import 'package:jwt_decoder/jwt_decoder.dart';

/// Determines whether a given access token is expired or not.
class CheckAccessTokenExpirationUseCase {
  /// Returns `true` if the given access token is expired.
  bool execute(String accessToken) {
    return JwtDecoder.isExpired(accessToken);
  }
}
