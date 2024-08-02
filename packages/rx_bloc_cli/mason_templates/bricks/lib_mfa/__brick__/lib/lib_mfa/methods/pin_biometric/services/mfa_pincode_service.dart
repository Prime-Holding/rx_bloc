import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../models/mfa_method_request.dart';
import '../../../models/mfa_response.dart';
import '../../../repositories/mfa_repository.dart';
import '../models/mfa_pin_code_payload.dart';

class MfaPinCodeService extends PinCodeService {
  final MfaRepository _mfaRepository;
  final MfaResponse _lastMfaResponse;

  MfaPinCodeService({
    required MfaRepository mfaRepository,
    required MfaResponse mfaResponse,
  })  : _mfaRepository = mfaRepository,
        _lastMfaResponse = mfaResponse;

  @override
  Future<String?> getPinCode() async {
    return null;
  }

  @override
  Future<int> getPinLength() async {
    return 4;
  }

  @override
  Future<bool> isPinCodeInSecureStorage() async {
    return true;
  }

  @override
  Future<dynamic> verifyPinCode(String pinCode) => _mfaRepository.authenticate(
        transactionId: _lastMfaResponse.transactionId,
        request: MfaMethodRequest(
          securityToken: _lastMfaResponse.securityToken,
          payload: MfaPinCodePayload(
            code: pinCode,
          ),
        ),
      );
}
