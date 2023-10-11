{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_source/remote/auth_matrix_data_source.dart';
import '../models/action_request.dart';
import '../models/auth_matrix_action_type.dart';
import '../models/auth_matrix_cancel_model.dart';
import '../models/auth_matrix_response.dart';
import '../models/auth_matrix_verify.dart';

class AuthMatrixRepository {
  AuthMatrixRepository(this._authMatrixDataSource, this._errorMapper);

  final AuthMatrixDataSource _authMatrixDataSource;
  final ErrorMapper _errorMapper;

  Future<void> cancelAuthMatrix(AuthMatrixCancelModel cancelModel) =>
      _errorMapper
          .execute(() => _authMatrixDataSource.cancelAuthMatrix(cancelModel));

  Future<AuthMatrixResponse> initiateAuthMatrix({
    required ActionRequest payload,
  }) =>
      _errorMapper.execute(
        () {
          switch (payload.action) {
            case AuthMatrixActionType.pinAndOtp:
              return _authMatrixDataSource.pinAndOtpAuthMatrix(payload);
            case AuthMatrixActionType.pinOnly:
              return _authMatrixDataSource.pinOnlyAuthMatrix(payload);
            case AuthMatrixActionType.none:
              throw UnimplementedError();
          }
        },
      );

  Future<AuthMatrixResponse> verifyAuthMatrix({
    required AuthMatrixVerify payload,
  }) =>
      _errorMapper.execute(
        () => _authMatrixDataSource.verifyAuthMatrix(
          payload.transactionId,
          payload,
        ),
      );
}
