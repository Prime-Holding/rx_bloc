{{> licence.dart }}

import 'package:shelf/shelf.dart';
import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

import '../services/users_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

// ignore_for_file: cascade_invocations

class UsersController extends ApiController {
  UsersController(this._usersService);

  final UsersService _usersService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/register',
      _registerHandler,
    );

    // needs to have an access token, mocked for now
    router.addRequest(
      RequestType.POST,
      '/api/users/me/email/confirm',
      _confirmEmailHandler,
    );

    // needs to have an access token first
    // router.addRequest(
    //   RequestType.GET,
    //   '/api/users/me',
    // );

    // needs to have an access token, mocked for now
    router.addRequest(
      RequestType.PATCH,
      '/api/users/me',
      _sendSmsCodeHandler,
    );
    // needs to have an access token, mocked for now
    router.addRequest(
      RequestType.POST,
      '/api/users/me/phone/confirm',
      _confirmSmsCodeHandler,
    );

    router.addRequest(
      RequestType.POST,
      '/api/users/me/phone/resend',
      _resendSmsCodeHandler,
    );

  }

  Future<Response> _registerHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final email = params['email'];
    final password = params['password'];

    return responseBuilder.buildOK(
      data: _usersService.registerOrFindUser(email, password).toJson(),
    );
  }

  Future<Response> _confirmEmailHandler(Request request) async {
    // final params = await request.bodyFromFormData();
    // final token = params['token'];

    /// mocked for now
    return responseBuilder.buildOK(
      data: _usersService
          .getUsers()
          .first
          .copyWith(
            confirmedCredentials:
                ConfirmedCredentialsModel(email: true, phone: false),
          )
          .toJson(),
    );
  }

  Future<Response> _sendSmsCodeHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final phoneNumber = params['phoneNumber'] as String?;

    // Mock a delay to simulate a real-world scenario
    await Future.delayed(const Duration(seconds: 1));

    if (phoneNumber == null ||
        phoneNumber.length < 12 ||
        // Mock an invalid phone number error
        phoneNumber.replaceAll(' ', '').contains('2345678')) {
      return responseBuilder.buildErrorResponse(
        BadRequestException('Invalid phone number format.'),
      );
    }

    /// mocked for now
    return responseBuilder.buildOK(
      data: _usersService
          .getUsers()
          .first
          .copyWith(phoneNumber: phoneNumber)
          .toJson(),
    );
  }

  Future<Response> _confirmSmsCodeHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final smsCode = params['smsCode'] as String?;

    // Mock a delay to simulate a real-world scenario
    await Future.delayed(const Duration(seconds: 1));

    if (smsCode == null || smsCode.length > 4|| smsCode == '1234') {
      return responseBuilder.buildErrorResponse(
        BadRequestException('Invalid or expired SMS code.'),
      );
    }

    /// mocked for now
    return responseBuilder.buildOK(
      data: _usersService
          .getUsers()
          .first
          .copyWith(
            role: UserRole.user,
            confirmedCredentials:
                ConfirmedCredentialsModel(email: true, phone: true),
          )
          .toJson(),
    );
  }

  Future<Response> _resendSmsCodeHandler(Request request) async {
    // Mock a delay to simulate a real-world scenario
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Send a new SMS code to the user using a real SMS service

    return responseBuilder.buildOK();
  }
}
