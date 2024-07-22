import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../models/auth_matrix_method_request.dart';
import '../../../models/auth_matrix_response.dart';
import '../../../repositories/auth_matrix_repository.dart';
import '../models/auth_matrix_pin_code_payload.dart';

class AuthMatrixPinCodeService extends PinCodeService {
  final AuthMatrixRepository _authMatrixRepository;
  final AuthMatrixResponse _lastAuthMatrixResponse;

  AuthMatrixResponse? _currentAuthMatrixResponse;

  AuthMatrixPinCodeService({
    required AuthMatrixRepository authMatrixRepository,
    required AuthMatrixResponse authMatrixResponse,
  })  : _authMatrixRepository = authMatrixRepository,
        _lastAuthMatrixResponse = authMatrixResponse;

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
  Future<bool> verifyPinCode(String pinCode) async {
    try {
      _currentAuthMatrixResponse = await _authMatrixRepository.authenticate(
        transactionId: _lastAuthMatrixResponse.transactionId,
        request: AuthMatrixMethodRequest(
          securityToken: _lastAuthMatrixResponse.securityToken,
          payload: AuthMatrixPinCodePayload(
            code: pinCode,
          ),
        ),
      );
    } catch (e) {
      //TODO: To be refactored once the https://github.com/Prime-Holding/widget_toolkit/issues/109 is published
      return false;
    }

    return true;
  }

  AuthMatrixResponse? get authMatrixResponse => _currentAuthMatrixResponse;

  void dispose() {
    _currentAuthMatrixResponse = null;
  }
}
