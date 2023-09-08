import 'package:uuid/uuid.dart';

import '../models/auth_matrix/auth_matrix_action_type.dart';
import '../models/auth_matrix/auth_matrix_response_model.dart';
import '../models/auth_matrix/auth_matrix_status.dart';

class AuthMatrixRepository {
  List<String> activeEndToEndIds = [];
  List<AuthMatrixResponseModel> matrixModels = [];

  AuthMatrixResponseModel generateNewResponse(
    String endToEndId,
    AuthMatrixActionType authMatrixActionType,
    String userData,
  ) {
    var model = AuthMatrixResponseModel(
      transactionId: generateTransactionId(),
      authZ: authMatrixActionType,
      status: AuthMatrixStatus.inProgress,
    );
    matrixModels.add(model);
    return model;
  }

  AuthMatrixResponseModel verifyResponse(
    dynamic userData,
    Map<String, dynamic> payload,
    String transactionId,
    AuthMatrixActionType authZ,
    String endToEndId,
  ) {
    final currentModel = matrixModels
        .firstWhere((element) => element.transactionId == transactionId);
    if (authZ == AuthMatrixActionType.pinAndOtp) {
      return currentModel.copyWith(
        authZ: AuthMatrixActionType.pinOnly,
        status: AuthMatrixStatus.inProgress,
      );
    } else {
      matrixModels
          .removeWhere((element) => element.transactionId == transactionId);
      activeEndToEndIds.removeWhere((element) => element == endToEndId);
      return currentModel.copyWith(
        authZ: AuthMatrixActionType.none,
        status: AuthMatrixStatus.authorized,
      );
    }
  }

  void removeEndToEndId(String endToEndId) =>
      activeEndToEndIds.removeWhere((element) => element == endToEndId);

  void removeAuthMatrixModel(String transactionId) => matrixModels
      .removeWhere((element) => element.transactionId == transactionId);

  void addEndToEndId(String endToEndId) => activeEndToEndIds.add(endToEndId);

  String generateTransactionId() => const Uuid().v4();

  List<String> getActiveEndToEndIds() => activeEndToEndIds;
}
