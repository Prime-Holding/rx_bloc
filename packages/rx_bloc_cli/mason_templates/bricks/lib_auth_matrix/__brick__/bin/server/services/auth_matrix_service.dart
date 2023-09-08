import '../models/auth_matrix/auth_matrix_action_type.dart';
import '../models/auth_matrix/auth_matrix_response_model.dart';
import '../repositories/auth_matrix_repository.dart';
import '../utils/server_exceptions.dart';

class AuthMatrixService {
  const AuthMatrixService(this._authMatrixRepository);

  final AuthMatrixRepository _authMatrixRepository;

  void authMatrixCancel(String endToEndId, String transactionId) {
    final getListOfEndToEndIds = _authMatrixRepository.getActiveEndToEndIds();
    if (getListOfEndToEndIds.contains(endToEndId)) {
      _authMatrixRepository.removeEndToEndId(endToEndId);
      _authMatrixRepository.removeAuthMatrixModel(transactionId);
    }
  }

  AuthMatrixResponseModel generateNewResponse(String endToEndId,
      AuthMatrixActionType authMatrixActionType, String userData) {
    final getListOfEndToEndIds = _authMatrixRepository.getActiveEndToEndIds();
    if (getListOfEndToEndIds.contains(endToEndId)) {
      throw BadRequestException('Already in progress');
    }
    _authMatrixRepository.addEndToEndId(endToEndId);

    return _authMatrixRepository.generateNewResponse(
        endToEndId, authMatrixActionType, userData);
  }

  AuthMatrixResponseModel verifyResponse(Map<String, dynamic> payload) {
    final transactionId = payload['transactionId'];
    final userData = payload['userData'];
    final requestPayload = payload['payload'];
    final endToEndId = payload['endToEndId'];
    final authZ =
        AuthMatrixActionType.toAuthMatrixActionType(payload['action']);

    return _authMatrixRepository.verifyResponse(
        userData, requestPayload, transactionId, authZ, endToEndId);
  }
}
