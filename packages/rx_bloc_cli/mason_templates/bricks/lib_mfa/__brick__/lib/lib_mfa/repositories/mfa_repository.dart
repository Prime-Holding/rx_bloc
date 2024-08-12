{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_source/remote/mfa_data_source.dart';
import '../models/mfa_method_request.dart';
import '../models/mfa_response.dart';
import '../models/payload/mfa_payload_request.dart';

class MfaRepository {
MfaRepository(this._mfaDataSource, this._errorMapper);

  final MfaDataSource _mfaDataSource;
  final ErrorMapper _errorMapper;

  /// Initiates the Multi-Factor Authentication process by the given [action] and [request].
  ///
  /// - [action] is the action to be performed such as `changeAddress`, `makeTransaction`, etc.
  /// - [request] is the request body that contains the necessary user data to initiate the process.
  /// - Returns an [MfaResponse] object that determines the next steps in the Multi-Factor Authentication process.
  Future<MfaResponse> initiate({
    required String action,
    required MfaPayloadRequest request,
  }) =>
      _errorMapper
          .execute(() => _mfaDataSource.initiate(action, request));

  /// Authenticates the user by the given [transactionId] and [request].
  ///
  /// - [transactionId] is the unique MFA transaction id.
  /// - [request] is the request body that contains the necessary user data to authenticate the user.
  ///  Returns an [MfaResponse] object that determines the next steps in the mfa process.
  Future<MfaResponse> authenticate({
    required String transactionId,
    required MfaMethodRequest request,
  }) =>
      _errorMapper.execute(
          () => _mfaDataSource.authenticate(transactionId, request));
}
