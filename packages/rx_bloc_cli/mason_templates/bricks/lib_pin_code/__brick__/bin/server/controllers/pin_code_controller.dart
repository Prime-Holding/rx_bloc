{{> licence.dart }}

import 'package:shelf/shelf.dart';

import '../services/pin_code_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';
import '../utils/utilities.dart';

class PinCodeController extends ApiController {
  PinCodeController(this._pinCodeService);

  final PinCodeService _pinCodeService;

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

    return responseBuilder.buildOK();
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
    return responseBuilder.buildOK();
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
    return responseBuilder.buildOK();
  }
}
