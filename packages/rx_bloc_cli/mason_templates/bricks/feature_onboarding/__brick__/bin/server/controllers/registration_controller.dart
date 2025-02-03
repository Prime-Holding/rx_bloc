{{> licence.dart }}

import 'package:shelf/shelf.dart';
import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';
import 'package:{{project_name}}/base/models/user_with_auth_token_model.dart';

import '../services/authentication_service.dart';
import '../services/users_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';
import '../utils/users_utilities.dart';

// ignore_for_file: cascade_invocations

class RegistrationController extends ApiController {
  RegistrationController(
    this._authenticationService,
    this._usersService,
  );

  final AuthenticationService _authenticationService;
  final UsersService _usersService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/register',
      _registerHandler,
    );

    router.addRequest(
      RequestType.POST,
      '/api/register/email/resend-confirmation',
      // mocked, since no email is actually sent
      (request) => myUserHandler(
        request,
        responseBuilder,
        _authenticationService,
        _usersService,
      ),
    );

    router.addRequest(
      RequestType.POST,
      '/api/register/email/confirm',
      _confirmEmailHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/register/phone/confirm',
      _confirmPhoneNumberHandler,
    );

    router.addRequest(
      RequestType.POST,
      '/api/register/phone/resend',
      _resendSmsCodeHandler,
    );
  }

  Future<Response> _registerHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final email = params['email'];
    final password = params['password'];

    final newUser = _usersService.registerOrFindUser(email, password);
    final token =
        _authenticationService.issueNewToken(null, userId: newUser.id);

    return responseBuilder.buildOK(
      data: UserWithAuthTokenModel(
        user: newUser,
        authToken: token.toAuthTokenModel,
      ).toJson(),
    );
  }

  Map<String, dynamic> _getUserJson(String userId) =>
      _usersService.getUserById(userId)!.toJson();

  Future<Response> _confirmEmailHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final token = params['token'];

    if (token == '00000000') {
      return responseBuilder.buildErrorResponse(
        ResponseException(400, 'Invalid token'),
      );
    }

    final userId =
        _authenticationService.getUserIdFromAuthHeader(request.headers);
    _usersService.updateUser(
      userId,
      confirmedCredentials:
          ConfirmedCredentialsModel(email: true, phone: false),
    );

    return responseBuilder.buildOK(
      data: _getUserJson(userId),
    );
  }

  Future<Response> _confirmPhoneNumberHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final smsCode = params['smsCode'] as String?;

    // Mock a delay to simulate a real-world scenario
    await Future.delayed(const Duration(seconds: 1));

    if (smsCode == null || smsCode.length > 4 || smsCode == '1234') {
      return responseBuilder.buildErrorResponse(
        BadRequestException('Invalid or expired code.'),
      );
    }

    final userId =
        _authenticationService.getUserIdFromAuthHeader(request.headers);
    final updateSuccess = _usersService.confirmPhoneNumber(userId);
    if (updateSuccess) _usersService.updateUser(userId, role: UserRole.user);

    return responseBuilder.buildOK(
      data: _getUserJson(userId),
    );
  }

  Future<Response> _resendSmsCodeHandler(Request request) async {
    // Mock a delay to simulate a real-world scenario
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Send a new SMS code to the user using a real SMS service

    return responseBuilder.buildOK();
  }
}
