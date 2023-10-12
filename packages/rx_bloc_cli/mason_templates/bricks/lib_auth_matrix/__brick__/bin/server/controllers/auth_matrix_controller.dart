{{> licence.dart }}

import 'package:shelf/shelf.dart';

import '../models/auth_matrix/auth_matrix_action_type.dart';
import '../services/auth_matrix_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class AuthMatrixController extends ApiController {
  AuthMatrixController(this._authMatrixService);

  final AuthMatrixService _authMatrixService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/authMatrix/actions/pinOnly',
      _authMatrixPinOnly,
    );
    router.addRequest(
      RequestType.POST,
      '/api/authMatrix/actions/pinAndOtp',
      _authMatrixPinAndOtp,
    );
    router.addRequest(
      RequestType.POST,
      '/api/authMatrix/<transactionId>',
      _authMatrixVerify,
    );
    router.addRequest(
      RequestType.DELETE,
      '/api/authMatrix/actions/cancel',
      _authMatrixCancel,
    );
  }

  Future<Response> _authMatrixCancel(Request request) async {
    final params = await request.bodyFromFormData();
    _authMatrixService.authMatrixCancel(
      params['endToEndId'],
      params['transactionId'],
    );
    return responseBuilder.buildOK();
  }

  Future<Response> _authMatrixPinOnly(Request request) async {
    final params = await request.bodyFromFormData();
    throwIfEmpty(
      params['endToEndId'],
      BadRequestException('Bad Request End to end id is empty'),
    );
    throwIfEmpty(
      params['userData'],
      BadRequestException('Bad Request User Data empty'),
    );
    return responseBuilder.buildOK(
        data: _authMatrixService
            .generateNewResponse(
              params['endToEndId'],
              AuthMatrixActionType.pinOnly,
              params['userData'],
            )
            .toJson());
  }

  Future<Response> _authMatrixPinAndOtp(Request request) async {
    final params = await request.bodyFromFormData();
    throwIfEmpty(
      params['endToEndId'],
      BadRequestException('Bad Request End to end id is empty'),
    );
    throwIfEmpty(
      params['userData'],
      BadRequestException('Bad Request User Data empty'),
    );
    return responseBuilder.buildOK(
        data: _authMatrixService
            .generateNewResponse(
              params['endToEndId'],
              AuthMatrixActionType.pinAndOtp,
              params['userData'],
            )
            .toJson());
  }

  Future<Response> _authMatrixVerify(Request request) async {
    var params = await request.bodyFromFormData();

    String? code;
    print(params['action']);
    if (params['action'] == 'PinOnly' && params['payload']['code'] == '1111') {
      code = params['payload']['code'];
    } else if (params['action'] == 'PinAndOtp' &&
        params['payload']['code'] == '0000') {
      code = params['payload']['code'];
    } else {
      _authMatrixService.authMatrixCancel(
        params['endToEndId'],
        params['transactionId'],
      );
    }
    throwIfEmpty(
      code,
      ForbiddenException('Pin/Otp code incorrect'),
    );

    return responseBuilder.buildOK(
        data: _authMatrixService.verifyResponse(params).toJson());
  }
}
