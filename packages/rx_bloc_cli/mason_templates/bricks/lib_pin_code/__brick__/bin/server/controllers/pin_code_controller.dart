{{> licence.dart }}

import 'package:shelf/shelf.dart';
import 'package:{{project_name}}/base/models/user_model.dart';

import '../services/pin_code_service.dart';
import '../services/users_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';
import '../utils/utilities.dart';

class PinCodeController extends ApiController {
  PinCodeController(this._pinCodeService, this._usersService);

  final PinCodeService _pinCodeService;
  final UsersService _usersService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/pin/create',
      _createPinCode,
    );
    router.addRequest(
      RequestType.POST,
      '/api/pin/verify',
      _verifyPinCode,
    );
    router.addRequest(
      RequestType.PATCH,
      '/api/pin/update',
      _updatePinCode,
    );
  }

  Future<Response> _createPinCode(Request request) async {
    final userId = getUserIdFromAuthToken(request.headers);

    final pinCode = (await request.bodyFromFormData())['pinCode'];
    throwIfEmpty(
      pinCode,
      BadRequestException('pinCode is required'),
    );

    _pinCodeService.savePinCode(userId, pinCode);

        final user = _usersService.getUserById(userId);

    if (user == null) {
      throw NotFoundException('User not found');
    }

    /// Update the user to have a pin code
    _usersService.updateUser(userId, hasPin: true);

    /// Return the user with the pin code
    return responseBuilder.buildOK(data: user.copyWith(hasPin: true).toJson());
  }

  Future<Response> _verifyPinCode(Request request) async {
    final userId = getUserIdFromAuthToken(request.headers);
    final requestBody = await request.bodyFromFormData();

    final pinCode = requestBody['pinCode'];
    throwIfEmpty(
      pinCode,
      BadRequestException('pinCode is required'),
    );

    _pinCodeService.verifyPinCode(userId, pinCode);

    final requestUpdateToken = requestBody['requestUpdateToken'];
    // If the client requests an update token, generate and return it
    if (requestUpdateToken ?? false) {
      final token = _pinCodeService.generateUpdateToken(userId);
      return responseBuilder.buildOK(data: {
        'token': token,
      });
    }
    return responseBuilder.buildOK(
      data: {'token': null},
    );
  }

  Future<Response> _updatePinCode(Request request) async {
    final userId = getUserIdFromAuthToken(request.headers);
    final requestBody = await request.bodyFromFormData();

    final token = requestBody['token'];
    throwIfEmpty(
      token,
      BadRequestException('token is required'),
    );

    final newPinCode = requestBody['pinCode'];
    throwIfEmpty(
      newPinCode,
      BadRequestException('pinCode is required'),
    );

    _pinCodeService.verifyUpdateToken(userId, token);

    // Save the new PIN code and remove the update token
    _pinCodeService
      ..savePinCode(userId, newPinCode)
      ..removeToken(userId);
    final user = _usersService.getUserById(userId);
    if (user == null) {
      throw NotFoundException('User not found');
    }

    return responseBuilder.buildOK(data: user.toJson());
  }
}
