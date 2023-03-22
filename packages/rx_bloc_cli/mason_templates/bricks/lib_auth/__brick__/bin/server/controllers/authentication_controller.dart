{{> licence.dart }}

import 'package:shelf/shelf.dart';

import '../services/authentication_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

// ignore_for_file: cascade_invocations

class AuthenticationController extends ApiController {
  static const authHeader = 'Authorization';
  final _authTokenRepository = AuthTokenRepository();

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/auth/refresh-token',
      _refreshTokenHandler,
    );

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
    {{#enable_feature_google_login}}
    router.addRequest(
      RequestType.POST,
      '/api/authenticate/google',
      _googleAuthHandler,
    );
    {{/enable_feature_google_login}}
  }

  {{#enable_feature_google_login}}
    Future<Response> _googleAuthHandler(Request request) async {
    final params = await request.bodyFromFormData();

    throwIfEmpty(
      params['email'],
      BadRequestException('An error ocurred.'),
    );
    throwIfEmpty(
      params['token'],
      BadRequestException('An error ocurred.'),
    );

    final token = _issueNewToken(null);
    return responseBuilder.buildOK(data: token.toJson());
  }
  {{/enable_feature_google_login}}

  bool isAuthenticated(Request request) {
    final headers = request.headers;
    if (!headers.containsKey(authHeader)) {
      throw UnauthorizedException('User not authorized!');
    }

    final accessToken = _getAccessTokenFromAuthHeader(request.headers);
    if (!_validateAccessToken(accessToken)) {
      throw UnauthorizedException('User not authorized!');
    }

    return true;
  }

  Future<Response> _refreshTokenHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final refreshToken = params['refreshToken'];

    final token = _issueNewToken(refreshToken);
    return responseBuilder.buildOK(data: token.toJson());
  }

  Future<Response> _authenticationHandler(Request request) async {
    final params = await request.bodyFromFormData();

    throwIfEmpty(
      params['username'],
      BadRequestException('The username cannot be empty.'),
    );
    throwIfEmpty(
      params['password'],
      BadRequestException('The password cannot be empty.'),
    );

    final token = _issueNewToken(null);
    return responseBuilder.buildOK(data: token.toJson());
  }

  Future<Response> _logoutHandler(Request request) async {
    await Future.delayed(const Duration(seconds: 1));
    isAuthenticated(request);

    final accessToken = _getAccessTokenFromAuthHeader(request.headers);
    _authTokenRepository.removeToken(accessToken);

    return responseBuilder.buildOK();
  }

  String _getAccessTokenFromAuthHeader(Map<String, String> headers) {
    try {
// Usually the auth header looks like 'Bearer token', but if the format
// is not respected, it may throw errors
      return headers[authHeader]?.split(' ')[1] ?? '';
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
      final token = _authTokenRepository.getTokenViaRefreshToken(refreshToken);
      if (token == null) throw BadRequestException('Invalid refresh token!');
      _authTokenRepository.removeToken(token.token);
    }

    return _authTokenRepository.issueNewToken();
  }
}
