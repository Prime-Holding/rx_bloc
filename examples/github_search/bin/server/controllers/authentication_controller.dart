import 'package:shelf/shelf.dart';

import '../models/auth_token.dart';
import '../repositories/auth_token_repository.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

// ignore_for_file: cascade_invocations

class AuthenticationController extends ApiController {
  static const _authHeader = 'Authorization';
  final _authTokenRepository = AuthTokenRepository();

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/authenticate',
      _authenticationHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/logout',
      _logoutHandler,
    );
  }

  bool isAuthenticated(Request request) {
    final headers = request.headers;
    if (!headers.containsKey(_authHeader)) {
      throw UnauthorizedException('User not authorized!');
    }

    final accessToken = _getAccessTokenFromAuthHeader(request.headers);
    if (!_validateAccessToken(accessToken)) {
      throw UnauthorizedException('User not authorized!');
    }

    return true;
  }

  Future<Response> _authenticationHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final refreshToken = params['refreshToken'];

    if (refreshToken == null || refreshToken.isEmpty) {
      throwIfEmpty(
        params['username'],
        BadRequestException('The username cannot be empty.'),
      );
      throwIfEmpty(
        params['password'],
        BadRequestException('The password cannot be empty.'),
      );
    }
    final _token = _issueNewToken(refreshToken);
    return responseBuilder.buildOK(data: _token.toJson());
  }

  Response _logoutHandler(Request request) {
    isAuthenticated(request);

    final accessToken = _getAccessTokenFromAuthHeader(request.headers);
    _authTokenRepository.removeToken(accessToken);

    return responseBuilder.buildOK();
  }

  String _getAccessTokenFromAuthHeader(Map<String, String> headers) {
    try {
      // Usually the auth header looks like 'Bearer token', but if the format
      // is not respected, it may throw errors
      return headers[_authHeader]?.split(' ')[1] ?? '';
    } catch (e) {
      return '';
    }
  }

  bool _validateAccessToken(String accessToken) {
    final token = _authTokenRepository.getToken(accessToken);
    if (token == null) {
      throw UnauthorizedException('Invalid access token!');
    }
    return token.isValid;
  }

  AuthToken _issueNewToken(String? refreshToken) {
    if (refreshToken != null) {
      final _tkn = _authTokenRepository.getTokenViaRefreshToken(refreshToken);
      if (_tkn == null) throw BadRequestException('Invalid refresh token!');
      _authTokenRepository.removeToken(_tkn.token);
    }

    return _authTokenRepository.issueNewToken();
  }
}
