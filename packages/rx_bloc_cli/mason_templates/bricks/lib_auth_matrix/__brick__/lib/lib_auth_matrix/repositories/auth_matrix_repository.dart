{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_source/remote/auth_matrix_data_source.dart';

import '../models/auth_matrix_method_request.dart';
import '../models/auth_matrix_response.dart';
import '../models/payload/auth_matrix_payload_request.dart';

class AuthMatrixRepository {
  AuthMatrixRepository(this._authMatrixDataSource, this._errorMapper);

  final AuthMatrixDataSource _authMatrixDataSource;
  final ErrorMapper _errorMapper;

  /// Deletes the auth matrix transaction by the given [transactionId].
  Future<void> deleteAuthTransaction(String transactionId) =>
      _errorMapper.execute(() => _authMatrixDataSource.delete(transactionId));

  /// Initiates the auth matrix process by the given [action] and [request].
  ///
  /// - [action] is the action to be performed such as `changeAddress`, `makeTransaction`, etc.
  /// - [request] is the request body that contains the necessary user data to initiate the process.
  /// - Returns an [AuthMatrixResponse] object that determines the next steps in the auth matrix process.
  Future<AuthMatrixResponse> initiate({
    required String action,
    required AuthMatrixPayloadRequest request,
  }) =>
      _errorMapper
          .execute(() => _authMatrixDataSource.initiate(action, request));

  /// Authenticates the user by the given [transactionId] and [request].
  ///
  /// - [transactionId] is the unique auth matrix transaction id.
  /// - [request] is the request body that contains the necessary user data to authenticate the user.
  ///  Returns an [AuthMatrixResponse] object that determines the next steps in the auth matrix process.
  Future<AuthMatrixResponse> authenticate({
    required String transactionId,
    required AuthMatrixMethodRequest request,
  }) =>
      _errorMapper.execute(
          () => _authMatrixDataSource.authenticate(transactionId, request));
}
