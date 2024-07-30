import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../models/tfa_method_request.dart';
import '../../../models/tfa_response.dart';
import '../../../repositories/tfa_repository.dart';
import '../models/tfa_pin_code_payload.dart';

class TFAPinCodeService extends PinCodeService {
  final TFARepository _tfaRepository;
  final TFAResponse _lastTFAResponse;

  TFAPinCodeService({
    required TFARepository tfaRepository,
    required TFAResponse tfaResponse,
  })  : _tfaRepository = tfaRepository,
        _lastTFAResponse = tfaResponse;

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
  Future<dynamic> verifyPinCode(String pinCode) => _tfaRepository.authenticate(
        transactionId: _lastTFAResponse.transactionId,
        request: TFAMethodRequest(
          securityToken: _lastTFAResponse.securityToken,
          payload: TFAPinCodePayload(
            code: pinCode,
          ),
        ),
      );
}
