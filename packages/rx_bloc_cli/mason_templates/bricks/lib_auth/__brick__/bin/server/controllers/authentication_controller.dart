{{> licence.dart }}

import 'package:shelf/shelf.dart';

import '../services/authentication_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

// ignore_for_file: cascade_invocations

class AuthenticationController extends ApiController {
  AuthenticationController(this._authenticationService);

  final AuthenticationService _authenticationService;

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

{{#enable_facebook_auth}}
router.addRequest(
RequestType.POST,
'/api/authenticate/facebook',
_facebookAuthHandler,
);
{{/enable_facebook_auth}}

    router.addRequest(
      RequestType.POST,
      '/api/logout',
      _logoutHandler,
    );
  }

  Future<Response> _refreshTokenHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final refreshToken = params['refreshToken'];

    final token = _authenticationService.issueNewToken(refreshToken);
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

    final token = _authenticationService.issueNewToken(null);
    return responseBuilder.buildOK(data: token.toJson());
  }
{{#enable_facebook_auth}}
Future<Response> _facebookAuthHandler(Request request) async {
final params = await request.bodyFromFormData();
if (params['isAuthenticated'] != true) {
BadRequestException('User must be authenticated to proceed');
}

final token = _authenticationService.issueNewToken(null);
return responseBuilder.buildOK(data: token.toJson());
}
{{/enable_facebook_auth}}


  Future<Response> _logoutHandler(Request request) async {
    await Future.delayed(const Duration(seconds: 1));
    _authenticationService.isAuthenticated(request);

    final accessToken =
        _authenticationService.getAccessTokenFromAuthHeader(request.headers);
    _authenticationService.removeToken(accessToken);

    return responseBuilder.buildOK();
  }
}
