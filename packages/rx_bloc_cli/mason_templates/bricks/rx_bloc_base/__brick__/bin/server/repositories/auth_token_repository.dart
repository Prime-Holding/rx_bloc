{{> licence.dart }}

import '../models/auth_token.dart';

/// Auth token repository stores and manages authentication tokens
class AuthTokenRepository {
  /// List of auth tokens accessible via the access tokens
  final Map<String, AuthToken> _tokens = {};

  /// List of auth tokens accessible via the refresh tokens
  final Map<String, AuthToken> _refreshTokens = {};

  /// Creates a new auth token
  AuthToken issueNewToken() {
    final token = AuthToken.generateNew();

    _tokens[token.token] = token;
    _refreshTokens[token.refreshToken] = token;

    return token;
  }

  /// Removes an auth token with the specified access token
  bool removeToken(String token) {
    final _token = _tokens[token];
    if (_token == null) return false;

    final refreshToken = _token.refreshToken;
    _tokens.remove(token);
    _refreshTokens.remove(refreshToken);

    return true;
  }

  /// Returns a token based on the provided access token
  AuthToken? getToken(String token) => _tokens[token];

  /// Returns a token based on the provided refresh token
  AuthToken? getTokenViaRefreshToken(String refreshToken) =>
      _refreshTokens[refreshToken];
}
