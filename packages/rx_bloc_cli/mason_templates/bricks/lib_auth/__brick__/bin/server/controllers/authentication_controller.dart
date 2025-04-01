{{> licence.dart }}

import 'package:shelf/shelf.dart';
import 'package:{{project_name}}/base/models/user_with_auth_token_model.dart';

import '../services/authentication_service.dart';
import '../services/users_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

// ignore_for_file: cascade_invocations

class AuthenticationController extends ApiController {
  AuthenticationController(
    this._authenticationService,
    this._usersService,
  );

  final AuthenticationService _authenticationService;
  final UsersService _usersService;

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
{{#enable_social_logins}}
    router.addRequest(
      RequestType.POST,
      '/api/authenticate/apple',
      _authenticateWithAppleHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/authenticate/google',
      _authenticateWithGoogleHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/authenticate/facebook',
      _authenticateWithFacebookHandler,
    );
{{/enable_social_logins}}
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

    final email = params['username'];
    final password = params['password'];

    /// If user exists, use it, otherwise create a new one
    final user = _usersService.getUserByEmail(email) ??
        _usersService.createRandomUser(email, password);

    /// Issue a new token for the user
    final token = _authenticationService.issueNewToken(null, userId: user.id);

    /// Return the user with the token
    return responseBuilder.buildOK(
      data: UserWithAuthTokenModel(
        user: user,
        authToken: token.toAuthTokenModel,
      ).toJson(),
    );
  }
{{#enable_social_logins}}
  Future<Response> _authenticateWithAppleHandler(Request request) async {
    final params = await request.bodyFromFormData();

    throwIfEmpty(
      params['authorizationCode'],
      BadRequestException('The user authorization with Apple failed'),
    );

    final token = _authenticationService.issueNewToken(null);
    return responseBuilder.buildOK(data: token.toJson());
  }

  Future<Response> _authenticateWithGoogleHandler(Request request) async {
    final params = await request.bodyFromFormData();

    throwIfEmpty(
      params['email'],
      BadRequestException('The user authorization with Google failed.'),
    );

    final token = _authenticationService.issueNewToken(null);
    return responseBuilder.buildOK(data: token.toJson());
  }
  
  Future<Response> _authenticateWithFacebookHandler(Request request) async {
    final params = await request.bodyFromFormData();
    if (params['isAuthenticated'] != true) {
    BadRequestException('User must be authenticated to proceed');
  }

final token = _authenticationService.issueNewToken(null);
return responseBuilder.buildOK(data: token.toJson());
}
  {{/enable_social_logins}}

  Future<Response> _logoutHandler(Request request) async {
    await Future.delayed(const Duration(seconds: 1));
    _authenticationService.isAuthenticated(request);

    final accessToken =
        _authenticationService.getAccessTokenFromAuthHeader(request.headers);
    _authenticationService.removeToken(accessToken);

    return responseBuilder.buildOK();
  }
}