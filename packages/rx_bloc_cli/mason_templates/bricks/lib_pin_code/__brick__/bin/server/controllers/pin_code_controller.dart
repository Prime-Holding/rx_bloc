// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

import '../config.dart';
import '../services/authentication_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';
import '../utils/utilities.dart';

class PinCodeController extends ApiController {
  final Map<String, String> _pinCodes = {};
  final Map<String, String> _tokens = {};

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.PATCH,
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

    final pinCode = (await request.bodyFromFormData())['pinCode']!;
    _pinCodes[userId] = pinCode;

    return responseBuilder.buildOK();
  }

  Future<Response> _verifyPinCode(Request request) async {
    final userId = _getUserIdFromAuthToken(request);

    final requestBody = await request.bodyFromFormData();
    final pinCode = requestBody['pinCode']!;
    final requestUpdateToken = requestBody['requestUpdateToken']!;

    if (pinCode != _pinCodes[userId]) {
      throw UnprocessableEntityException('Incorrect PIN code');
    }

    _tokens[userId] = generateRandomString();
    return responseBuilder.buildOK(data: {
      if (requestUpdateToken) 'token': _tokens[userId],
    });
  }

  Future<Response> _updatePinCode(Request request) async {
    final userId = _getUserIdFromAuthToken(request);

    final requestBody = await request.bodyFromFormData();
    final token = requestBody['token']!;
    final newPinCode = requestBody['pinCode']!;

    if (token != _tokens[userId]) {
      throw UnprocessableEntityException('Incorrect PIN code');
    }

    _pinCodes[userId] = newPinCode;
    _tokens.remove(userId);
    return responseBuilder.buildOK();
  }
}
