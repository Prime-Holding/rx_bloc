{{> licence.dart }}

import 'package:shelf/shelf.dart';
import 'package:testapp/lib_auth_matrix/methods/otp/models/auth_matrix_otp_payload.dart';
import 'package:testapp/lib_auth_matrix/methods/pin_biometric/models/auth_matrix_pin_code_payload.dart';
import 'package:testapp/lib_auth_matrix/models/auth_matrix_action.dart';
import 'package:testapp/lib_auth_matrix/models/auth_matrix_method.dart';
import 'package:testapp/lib_auth_matrix/models/auth_matrix_method_request.dart';
import 'package:testapp/lib_auth_matrix/models/auth_matrix_response.dart';
import 'package:testapp/lib_auth_matrix/models/payload/response/auth_matrix_last_login_payload_response.dart';

import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class AuthMatrixController extends ApiController {
  AuthMatrixController();

  static const String _changeAddressTransactionId = '1';
  static const String _changeAddressSecurityToken1 = 'dasfgfsde123fd';
  static const String _changeAddressSecurityToken2 = '123ewf1gdfsasd';
  static const String _changeAddressSecurityToken3 = '123ew2fsdfsasd';

  static const String _unlockTransactionId = '2';
  static const String _unlockSecurityToken1 = '2dasfgfsde123fd';
  static const String _unlockSecurityToken2 = '2123ewf1gdfsasd';

  static const String _otpCode = '0000';
  static const String _otpIncorrectCompleteCode = '3333';
  static const String _pinCode = '0000';

  String get _expiresDate =>
      DateTime.now().add(const Duration(seconds: 60)).toIso8601String();

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/auth-matrix/actions/${AuthMatrixAction.changeAddress.name}',
      _initiateChangeAddress,
    );

    router.addRequest(
      RequestType.POST,
      '/api/auth-matrix/$_changeAddressTransactionId',
      _authenticateChangeAddress,
    );

    router.addRequest(
      RequestType.POST,
      '/api/auth-matrix/actions/${AuthMatrixAction.unlock.name}',
      _initiateUnlock,
    );

    router.addRequest(
      RequestType.POST,
      '/api/auth-matrix/$_unlockTransactionId',
      _authenticateUnlock,
    );

    router.addRequest(
      RequestType.DELETE,
      '/api/auth-matrix/<transactionId>',
      _authMatrixCancel,
    );
  }

  Future<Response> _authMatrixCancel(Request request) async =>
      responseBuilder.buildOK();

  Future<Response> _initiateChangeAddress(Request request) async =>
      responseBuilder.buildOK(
        data: AuthMatrixResponse(
          authMethod: AuthMatrixMethod.pinBiometric,
          documentIds: [1],
          expires: _expiresDate,
          securityToken: _changeAddressSecurityToken1,
          transactionId: _changeAddressTransactionId,
        ).toJson(),
      );

  Future<Response> _authenticateChangeAddress(Request request) async {
    final formData = await request.bodyFromFormData();

    await Future.delayed(const Duration(milliseconds: 300));

    _validateAuthRequest(formData);

    return responseBuilder.buildOK(
      data: switch (formData['securityToken'] as String) {
        (_changeAddressSecurityToken1) => AuthMatrixResponse(
          authMethod: AuthMatrixMethod.otp,
          documentIds: [1],
          expires: _expiresDate,
          securityToken: _changeAddressSecurityToken2,
          transactionId: _changeAddressTransactionId,
        ),
        (_changeAddressSecurityToken2) => AuthMatrixResponse(
          authMethod: AuthMatrixMethod.complete,
          documentIds: [1],
          expires: _expiresDate,
          securityToken: _changeAddressSecurityToken3,
          transactionId: _changeAddressTransactionId,
        ),
        String() => throw UnimplementedError(),
      }
          .toJson(),
    );
  }

  Future<Response> _initiateUnlock(Request request) async =>
      responseBuilder.buildOK(
        data: AuthMatrixResponse(
          authMethod: AuthMatrixMethod.pinBiometric,
          documentIds: [1],
          expires: _expiresDate,
          securityToken: _unlockSecurityToken1,
          transactionId: _unlockTransactionId,
        ).toJson(),
      );

  Future<Response> _authenticateUnlock(Request request) async {
    _validateAuthRequest(await request.bodyFromFormData());

    return responseBuilder.buildOK(
      data: AuthMatrixResponse(
        authMethod: AuthMatrixMethod.complete,
        documentIds: [1],
        expires: _expiresDate,
        securityToken: _unlockSecurityToken2,
        transactionId: _unlockTransactionId,
        payload: AuthMatrixLastLoginPayloadResponse(
          lastLogin: DateTime.now(),
        ),
      ).toJson(),
    );
  }

  void _validateAuthRequest(Map<String, dynamic> formData) {
    final methodRequest = AuthMatrixMethodRequest.fromJson(formData);

    if (methodRequest.payload.type == AuthMatrixMethod.pinBiometric.name) {
      final payload = methodRequest.payload as AuthMatrixPinCodePayload;

      if (payload.code != _pinCode) {
        throw BadRequestException('The pin code should be $_pinCode');
      }
    }

    if (methodRequest.payload.type == AuthMatrixMethod.otp.name) {
      final payload = methodRequest.payload as AuthMatrixOTPPayload;

      if (payload.code == _otpIncorrectCompleteCode) {
        throw NotFoundException(
            'This error will complete the matrix for demo purposes.');
      }

      if (payload.code != _otpCode) {
        throw BadRequestException('The OTP code should be $_otpCode');
      }
    }
  }
}
