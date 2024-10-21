{{> licence.dart }}

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

import '../config.dart';
import '../services/authentication_service.dart';
import '../services/pin_code_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

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

  String _getUserIdFromAuthToken(Request request) {
    final authToken =
        request.headers[AuthenticationService.authHeader]?.split(' ')[1] ?? '';

    final JwtClaim decClaimSet = verifyJwtHS256Signature(
      authToken,
      jwtSigningKey,
      maxAge: const Duration(hours: 1),
    );
    decClaimSet.validate(
      issuer: jwtIssuer,
      audience: jwtAudiences.first,
    );
    return decClaimSet.payload['userId'];
  }

  Future<Response> _createPinCode(Request request) async {
    final userId = _getUserIdFromAuthToken(request);

    final pinCode = (await request.bodyFromFormData())['pinCode'];
    throwIfEmpty(
      pinCode,
      BadRequestException('pinCode is required'),
    );

    _pinCodeService.savePinCode(userId, pinCode);

    return responseBuilder.buildOK();
  }

  Future<Response> _verifyPinCode(Request request) async {
    final userId = _getUserIdFromAuthToken(request);
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
    final userId = _getUserIdFromAuthToken(request);
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
