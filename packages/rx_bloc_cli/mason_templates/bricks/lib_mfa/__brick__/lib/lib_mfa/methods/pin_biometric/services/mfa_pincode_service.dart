import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../models/mfa_method_request.dart';
import '../../../models/mfa_response.dart';
import '../../../repositories/mfa_repository.dart';
import '../models/mfa_pin_code_payload.dart';

class MFAPinCodeService extends PinCodeService {
  final MFARepository _mfaRepository;
  final MFAResponse _lastMFAResponse;

  MFAPinCodeService({
    required MFARepository mfaRepository,
    required MFAResponse mfaResponse,
  })  : _mfaRepository = mfaRepository,
        _lastMFAResponse = mfaResponse;

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
        transactionId: _lastMFAResponse.transactionId,
        request: MFAMethodRequest(
          securityToken: _lastMFAResponse.securityToken,
          payload: MFAPinCodePayload(
            code: pinCode,
          ),
        ),
      );
}
