{{> licence.dart }}

import 'package:shelf/shelf.dart';
import 'package:testapp/base/models/user_model.dart';
import 'package:testapp/base/models/user_role.dart';

import '../services/authentication_service.dart';
import '../services/users_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';
import '../utils/users_utilities.dart';

// ignore_for_file: cascade_invocations

class UsersController extends ApiController {
  UsersController(
    this._authenticationService,
    this._usersService,
  );

  final AuthenticationService _authenticationService;
  final UsersService _usersService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/users/me',
      (request) => myUserHandler(
        request,
        responseBuilder,
        _authenticationService,
        _usersService,
      ),
    );

    router.addRequest(
      RequestType.PATCH,
      '/api/users/me',
      _sendSmsCodeHandler,
    );

    router.addRequest(
      RequestType.PATCH,
      '/api/users/me/email',
      _updateUserEmailHandler,
    );

    router.addRequest(
      RequestType.POST,
      '/api/users/me/email/confirm',
      _verifyNewEmailHandler,
    );

    router.addRequest(
      RequestType.POST,
      '/api/users/me/email/resend-confirmation',
      _resendEmailVerificationHandler,
    );
  }

  /// Resend Email Verification
  Future<Response> _resendEmailVerificationHandler(Request request) async {
    final userId =
        _authenticationService.getUserIdFromAuthHeader(request.headers);
    final user = _usersService.getUserById(userId)!;

    // Mock a delay to simulate a real-world scenario
    await Future.delayed(const Duration(seconds: 1));

    // Mock an error
    if (user.email.contains('error')) {
      return responseBuilder.buildErrorResponse(
        InternalServerErrorException('Invalid or expired user.'),
      );
    }

    return responseBuilder.buildOK(
      data: _getUserJson(userId),
    );
  }

  /// Verify New Email
  Future<Response> _verifyNewEmailHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final token = params['token'] as String?;
    final userId =
        _authenticationService.getUserIdFromAuthHeader(request.headers);

    if (token == '00000000') {
      // Delete the temporary user created in the email change process
      _usersService.deleteUser(userId, UserRole.tempUser);
      return responseBuilder.buildErrorResponse(
        ResponseException(400, 'Invalid token'),
      );
    }

    // delete the old user and create a new one with the new email
    _usersService.deleteUser(userId, UserRole.user);
    _usersService.updateUser(userId, role: UserRole.user);

    return responseBuilder.buildOK(
      data: _getUserJson(userId),
    );
  }

  /// Initiate Email Change
  Future<Response> _updateUserEmailHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final email = params['email'] as String?;

    //check if the email is already in use
    if (email != null && _usersService.isEmailInUse(email)) {
      return responseBuilder.buildErrorResponse(
        RequestConflictException('This email is already in use.'),
      );
    }

    if (email == null || !email.contains('@')) {
      return responseBuilder.buildErrorResponse(
        UnprocessableEntityException('Invalid email format.'),
      );
    }

    final userId =
        _authenticationService.getUserIdFromAuthHeader(request.headers);
    final user = _usersService.getUserById(userId);

    if (user == null) {
      throw NotFoundException('User not found.');
    }
    // Create a
    _usersService.createUser(
      user.copyWith(email: email, role: UserRole.tempUser),
    );

    return responseBuilder.buildOK(
      data: user.toJson(),
    );
  }

  Map<String, dynamic> _getUserJson(String userId) =>
      _usersService.getUserById(userId)!.toJson();

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

    final userId =
        _authenticationService.getUserIdFromAuthHeader(request.headers);
    _usersService.updateUser(
      userId,
      phoneNumber: phoneNumber,
    );

    return responseBuilder.buildOK(
      data: _getUserJson(userId),
    );
  }
}
