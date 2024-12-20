{{> licence.dart }}

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

import '../config.dart';
import '../models/auth_token.dart';
import '../repositories/auth_token_repository.dart';
import '../utils/server_exceptions.dart';

class AuthenticationService {
  const AuthenticationService(this._authTokenRepository);

  final AuthTokenRepository _authTokenRepository;

  static const authHeader = 'Authorization';

  bool isAuthenticated(Request request) {
    final headers = request.headers;
    if (!headers.containsKey(authHeader)) {
      throw UnauthorizedException('User not authorized!');
    }

    final accessToken = getAccessTokenFromAuthHeader(request.headers);
    if (!_validateAccessToken(accessToken)) {
      throw UnauthorizedException('User not authorized!');
    }

    return true;
  }

  String getAccessTokenFromAuthHeader(Map<String, String> headers) {
    try {
      // Usually the auth header looks like 'Bearer token', but if the format
      // is not respected, it may throw errors
      return headers[authHeader]?.split(' ')[1] ?? '';
    } catch (e) {
      return '';
    }
  }

  String getUserIdFromAuthHeader(Map<String, String> headers) {
    final accessToken = getAccessTokenFromAuthHeader(headers);

    final JwtClaim decClaimSet =
        verifyJwtHS256Signature(accessToken, jwtSigningKey);
    decClaimSet.validate(
      issuer: jwtIssuer,
      audience: jwtAudiences.first,
    );

    final userId = decClaimSet.payload['userId'];
    if (userId == null) {
      throw UnauthorizedException('Invalid access token!');
    }
    return userId;
  }

  bool _validateAccessToken(String accessToken) {
    final token = _authTokenRepository.getToken(accessToken);
    if (token == null) {
      throw UnauthorizedException('Invalid access token!');
    }
    return token.isValid;
  }

  AuthToken issueNewToken(
    String? refreshToken, {
    String? userId,
  }) {
    if (refreshToken != null) {
      final token = _authTokenRepository.getTokenViaRefreshToken(refreshToken);
      if (token == null) throw BadRequestException('Invalid refresh token!');
      removeToken(token.token);
    }

    return _authTokenRepository.issueNewToken(userId);
  }

  void removeToken(String accessToken) =>
      _authTokenRepository.removeToken(accessToken);
}
