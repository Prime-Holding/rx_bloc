import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../models/auth_matrix_method_request.dart';
import '../../../models/auth_matrix_response.dart';
import '../../../repositories/auth_matrix_repository.dart';
import '../models/auth_matrix_pin_code_payload.dart';

class AuthMatrixPinCodeService extends PinCodeService {
  final AuthMatrixRepository _authMatrixRepository;
  final AuthMatrixResponse _lastAuthMatrixResponse;

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
  Future<dynamic> verifyPinCode(String pinCode) =>
      _authMatrixRepository.authenticate(
        transactionId: _lastAuthMatrixResponse.transactionId,
        request: AuthMatrixMethodRequest(
          securityToken: _lastAuthMatrixResponse.securityToken,
          payload: AuthMatrixPinCodePayload(
            code: pinCode,
          ),
        ),
      );
}
