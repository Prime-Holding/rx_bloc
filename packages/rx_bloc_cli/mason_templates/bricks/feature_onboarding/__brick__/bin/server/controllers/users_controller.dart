{{> licence.dart }}

import 'package:shelf/shelf.dart';

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
