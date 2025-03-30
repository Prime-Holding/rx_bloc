{{> licence.dart }}

import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';

import '../services/users_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class PasswordResetController extends ApiController {
  PasswordResetController(
    this._usersService,
  );

  final UsersService _usersService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/password-reset/request',
      _requestHandler,
    );

    router.addRequest(
      RequestType.POST,
      '/api/password-reset/confirm',
      _confirmHandler,
    );
  }

  Future<Response> _requestHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final email = params['email'];

    if (_usersService.isPasswordResetLockedForUser(email)) {
      final timeout = _usersService.getPasswordResetTimeoutForUser(email);
      return responseBuilder.buildErrorResponse(
        ResponseException(
          429,
          'Too many requests. Please try again in $timeout seconds.',
        ),
      );
    }

    _usersService.lockPasswordResetForUser(email);

    return responseBuilder.buildOK();
  }

  Future<Response> _confirmHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final token = params['token'];
    final newPassword = params['new_password'];

    if (token == '00000000') {
      return responseBuilder.buildErrorResponse(
        ResponseException(400, 'Invalid token'),
      );
    }

    if (newPassword == null ||
        newPassword.length < 6 ||
        newPassword == '123456') {
      return responseBuilder.buildErrorResponse(
        BadRequestException('Password does not meet strength requirements.'),
      );
    }

    _usersService.setPasswordForUser(
      token,
      sha256.convert(newPassword.codeUnits).toString(),
    );

    return responseBuilder.buildOK();
  }
}
