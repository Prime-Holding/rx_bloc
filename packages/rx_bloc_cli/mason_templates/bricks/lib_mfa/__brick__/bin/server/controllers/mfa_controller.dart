{{> licence.dart }}

import 'package:shelf/shelf.dart';
import 'package:{{project_name}}/lib_mfa/methods/otp/models/mfa_otp_payload.dart';
import 'package:{{project_name}}/lib_mfa/methods/pin_biometric/models/mfa_pin_code_payload.dart';
import 'package:{{project_name}}/lib_mfa/models/payload/response/mfa_last_login_payload_response.dart';
import 'package:{{project_name}}/lib_mfa/models/mfa_action.dart';
import 'package:{{project_name}}/lib_mfa/models/mfa_method.dart';
import 'package:{{project_name}}/lib_mfa/models/mfa_method_request.dart';
import 'package:{{project_name}}/lib_mfa/models/mfa_response.dart';


import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class MfaController extends ApiController {
  MfaController();

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
      '/api/mfa/actions/${MfaAction.changeAddress.name}',
      _initiateChangeAddress,
    );

    router.addRequest(
      RequestType.POST,
      '/api/mfa/$_changeAddressTransactionId',
      _authenticateChangeAddress,
    );

    router.addRequest(
      RequestType.POST,
      '/api/mfa/actions/${MfaAction.unlock.name}',
      _initiateUnlock,
    );

    router.addRequest(
      RequestType.POST,
      '/api/mfa/$_unlockTransactionId',
      _authenticateUnlock,
    );

    router.addRequest(
      RequestType.DELETE,
      '/api/mfa/<transactionId>',
      _mfaCancel,
    );
  }

  Future<Response> _mfaCancel(Request request) async =>
      responseBuilder.buildOK();

  Future<Response> _initiateChangeAddress(Request request) async =>
      responseBuilder.buildOK(
        data: MfaResponse(
          authMethod: MfaMethod.pinBiometric,
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
        (_changeAddressSecurityToken1) => MfaResponse(
            authMethod: MfaMethod.otp,
            documentIds: [1],
            expires: _expiresDate,
            securityToken: _changeAddressSecurityToken2,
            transactionId: _changeAddressTransactionId,
          ),
        (_changeAddressSecurityToken2) => MfaResponse(
            authMethod: MfaMethod.complete,
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
        data: MfaResponse(
          authMethod: MfaMethod.pinBiometric,
          documentIds: [1],
          expires: _expiresDate,
          securityToken: _unlockSecurityToken1,
          transactionId: _unlockTransactionId,
        ).toJson(),
      );

  Future<Response> _authenticateUnlock(Request request) async {
    _validateAuthRequest(await request.bodyFromFormData());

    return responseBuilder.buildOK(
      data: MfaResponse(
        authMethod: MfaMethod.complete,
        documentIds: [1],
        expires: _expiresDate,
        securityToken: _unlockSecurityToken2,
        transactionId: _unlockTransactionId,
        payload: MfaLastLoginPayloadResponse(
          lastLogin: DateTime.now(),
        ),
      ).toJson(),
    );
  }

  void _validateAuthRequest(Map<String, dynamic> formData) {
    final methodRequest = MfaMethodRequest.fromJson(formData);

    if (methodRequest.payload.type == MfaMethod.pinBiometric.name) {
      final payload = methodRequest.payload as MfaPinCodePayload;

      if (payload.code != _pinCode) {
        throw UnprocessableEntityException('The pin code should be $_pinCode');
      }
    }

    if (methodRequest.payload.type == MfaMethod.otp.name) {
      final payload = methodRequest.payload as MfaOtpPayload;

      if (payload.code == _otpIncorrectCompleteCode) {
        throw NotFoundException(
            'This error will complete the MFA for demo purposes.');
      }

      if (payload.code != _otpCode) {
        throw UnprocessableEntityException('The OTP code should be $_otpCode');
      }
    }
  }
}
