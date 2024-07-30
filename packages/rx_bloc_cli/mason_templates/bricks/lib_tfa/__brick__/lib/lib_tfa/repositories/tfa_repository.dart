{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_source/remote/tfa_data_source.dart';
import '../models/payload/tfa_payload_request.dart';
import '../models/tfa_method_request.dart';
import '../models/tfa_response.dart';

class TFARepository {
TFARepository(this._tfaDataSource, this._errorMapper);

  final TFADataSource _tfaDataSource;
  final ErrorMapper _errorMapper;

  /// Initiates the Two-Factor Authentication process by the given [action] and [request].
  ///
  /// - [action] is the action to be performed such as `changeAddress`, `makeTransaction`, etc.
  /// - [request] is the request body that contains the necessary user data to initiate the process.
  /// - Returns an [TFAResponse] object that determines the next steps in the Two-Factor Authentication process.
  Future<TFAResponse> initiate({
    required String action,
    required TFAPayloadRequest request,
  }) =>
      _errorMapper
          .execute(() => _tfaDataSource.initiate(action, request));

  /// Authenticates the user by the given [transactionId] and [request].
  ///
  /// - [transactionId] is the unique TFA transaction id.
  /// - [request] is the request body that contains the necessary user data to authenticate the user.
  ///  Returns an [TFAResponse] object that determines the next steps in the tfa process.
  Future<TFAResponse> authenticate({
    required String transactionId,
    required TFAMethodRequest request,
  }) =>
      _errorMapper.execute(
          () => _tfaDataSource.authenticate(transactionId, request));
}
