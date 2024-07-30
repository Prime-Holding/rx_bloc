import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../../models/tfa_method_request.dart';
import '../../../models/tfa_response.dart';
import '../../../repositories/tfa_repository.dart';
import '../models/tfa_otp_payload.dart';

class TFAOtpService extends SmsCodeService {
  final TFARepository _tfaRepository;
  final TFAResponse _lastTFAResponse;

  TFAOtpService({
    required TFARepository tfaRepository,
    required TFAResponse lastTFAResponse,
  })  : _tfaRepository = tfaRepository,
        _lastTFAResponse = lastTFAResponse;

  /// Confirms the phone code by the given [code] by sending it to the server.
  ///
  /// - [code] is the code that the user has received.
  /// Returns a [Future] of [TFAResponse] that determines the next steps in the Two-Factor Authentication process.
  @override
  Future<dynamic> confirmPhoneCode(String code) async =>
      await _tfaRepository.authenticate(
        transactionId: _lastTFAResponse.transactionId,
        request: TFAMethodRequest(
          securityToken: _lastTFAResponse.securityToken,
          payload: TFAOTPPayload(
            code: code,
          ),
        ),
      );

  @override
  Future<int> getCodeLength() async {
    return 4;
  }

  @override
  Future<String> getFullPhoneNumber() async {
    return '+359 123 456 789';
  }

  @override
  Future<int> getResendButtonThrottleTime(bool reset) async {
    return 1;
  }

  @override
  Future<int> getValidityTime(bool reset) async {
    return 60;
  }

  @override
  Future<bool> sendConfirmationSms(String usersPhoneNumber) async {
    return true;
  }

  @override
  Future<String> updatePhoneNumber(String newNumber) async {
    return '+359 123 456 789';
  }
}
