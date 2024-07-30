import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../../models/mfa_method_request.dart';
import '../../../models/mfa_response.dart';
import '../../../repositories/mfa_repository.dart';
import '../models/mfa_otp_payload.dart';

class MFAOtpService extends SmsCodeService {
  final MFARepository _mfaRepository;
  final MFAResponse _lastMFAResponse;

  MFAOtpService({
    required MFARepository mfaRepository,
    required MFAResponse lastMFAResponse,
  })  : _mfaRepository = mfaRepository,
        _lastMFAResponse = lastMFAResponse;

  /// Confirms the phone code by the given [code] by sending it to the server.
  ///
  /// - [code] is the code that the user has received.
  /// Returns a [Future] of [MFAResponse] that determines the next steps in the Multi-Factor Authentication process.
  @override
  Future<dynamic> confirmPhoneCode(String code) async =>
      await _mfaRepository.authenticate(
        transactionId: _lastMFAResponse.transactionId,
        request: MFAMethodRequest(
          securityToken: _lastMFAResponse.securityToken,
          payload: MFAOTPPayload(
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
