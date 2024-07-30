{{> licence.dart }}

import 'package:shelf/shelf.dart';
import 'package:{{project_name}}/lib_tfa/methods/otp/models/tfa_otp_payload.dart';
import 'package:{{project_name}}/lib_tfa/methods/pin_biometric/models/tfa_pin_code_payload.dart';
import 'package:{{project_name}}/lib_tfa/models/payload/response/tfa_last_login_payload_response.dart';
import 'package:{{project_name}}/lib_tfa/models/tfa_action.dart';
import 'package:{{project_name}}/lib_tfa/models/tfa_method.dart';
import 'package:{{project_name}}/lib_tfa/models/tfa_method_request.dart';
import 'package:{{project_name}}/lib_tfa/models/tfa_response.dart';


import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class TFAController extends ApiController {
  TFAController();

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
      '/api/tfa/actions/${TFAAction.changeAddress.name}',
      _initiateChangeAddress,
    );

    router.addRequest(
      RequestType.POST,
      '/api/tfa/$_changeAddressTransactionId',
      _authenticateChangeAddress,
    );

    router.addRequest(
      RequestType.POST,
      '/api/tfa/actions/${TFAAction.unlock.name}',
      _initiateUnlock,
    );

    router.addRequest(
      RequestType.POST,
      '/api/tfa/$_unlockTransactionId',
      _authenticateUnlock,
    );

    router.addRequest(
      RequestType.DELETE,
      '/api/tfa/<transactionId>',
      _tfaCancel,
    );
  }

  Future<Response> _tfaCancel(Request request) async =>
      responseBuilder.buildOK();

  Future<Response> _initiateChangeAddress(Request request) async =>
      responseBuilder.buildOK(
        data: TFAResponse(
          authMethod: TFAMethod.pinBiometric,
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
        (_changeAddressSecurityToken1) => TFAResponse(
            authMethod: TFAMethod.otp,
            documentIds: [1],
            expires: _expiresDate,
            securityToken: _changeAddressSecurityToken2,
            transactionId: _changeAddressTransactionId,
          ),
        (_changeAddressSecurityToken2) => TFAResponse(
            authMethod: TFAMethod.complete,
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
        data: TFAResponse(
          authMethod: TFAMethod.pinBiometric,
          documentIds: [1],
          expires: _expiresDate,
          securityToken: _unlockSecurityToken1,
          transactionId: _unlockTransactionId,
        ).toJson(),
      );

  Future<Response> _authenticateUnlock(Request request) async {
    _validateAuthRequest(await request.bodyFromFormData());

    return responseBuilder.buildOK(
      data: TFAResponse(
        authMethod: TFAMethod.complete,
        documentIds: [1],
        expires: _expiresDate,
        securityToken: _unlockSecurityToken2,
        transactionId: _unlockTransactionId,
        payload: TFALastLoginPayloadResponse(
          lastLogin: DateTime.now(),
        ),
      ).toJson(),
    );
  }

  void _validateAuthRequest(Map<String, dynamic> formData) {
    final methodRequest = TFAMethodRequest.fromJson(formData);

    if (methodRequest.payload.type == TFAMethod.pinBiometric.name) {
      final payload = methodRequest.payload as TFAPinCodePayload;

      if (payload.code != _pinCode) {
        throw UnprocessableEntityException('The pin code should be $_pinCode');
      }
    }

    if (methodRequest.payload.type == TFAMethod.otp.name) {
      final payload = methodRequest.payload as TFAOTPPayload;

      if (payload.code == _otpIncorrectCompleteCode) {
        throw NotFoundException(
            'This error will complete the 2FA for demo purposes.');
      }

      if (payload.code != _otpCode) {
        throw UnprocessableEntityException('The OTP code should be $_otpCode');
      }
    }
  }
}
