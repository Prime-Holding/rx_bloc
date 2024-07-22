import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../../models/auth_matrix_method_request.dart';
import '../../../models/auth_matrix_response.dart';
import '../../../repositories/auth_matrix_repository.dart';
import '../models/auth_matrix_otp_payload.dart';

class AuthMatrixOtpService extends SmsCodeService {
  final AuthMatrixRepository _authMatrixRepository;
  final AuthMatrixResponse _lastAuthMatrixResponse;

  AuthMatrixOtpService({
    required AuthMatrixRepository authMatrixRepository,
    required AuthMatrixResponse lastAuthMatrixResponse,
  })  : _authMatrixRepository = authMatrixRepository,
        _lastAuthMatrixResponse = lastAuthMatrixResponse;

  /// Confirms the phone code by the given [code] by sending it to the server.
  ///
  /// - [code] is the code that the user has received.
  /// Returns a [Future] of [AuthMatrixResponse] that determines the next steps in the auth matrix process.
  @override
  Future confirmPhoneCode(String code) async =>
      await _authMatrixRepository.authenticate(
        transactionId: _lastAuthMatrixResponse.transactionId,
        request: AuthMatrixMethodRequest(
          securityToken: _lastAuthMatrixResponse.securityToken,
          payload: AuthMatrixOTPPayload(
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
