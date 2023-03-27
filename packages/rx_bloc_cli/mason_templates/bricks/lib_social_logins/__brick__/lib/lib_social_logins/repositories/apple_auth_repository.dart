{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../lib_auth/models/auth_token_model.dart';
import '../data_sources/apple_auth_data_source.dart';
import '../data_sources/apple_credential_data_source.dart';
import '../models/apple_auth_request_model.dart';
import '../models/apple_credential_model.dart';

class AppleAuthRepository {
  AppleAuthRepository(
    this._errorMapper,
    this._appleAuthDataSource,
    this._appleCredentialDataSource,
  );

  final ErrorMapper _errorMapper;
  final AppleAuthDataSource _appleAuthDataSource;
  final AppleCredentialDataSource _appleCredentialDataSource;

  Future<AuthTokenModel> authenticateWithApple(
          {required AppleCredentialModel credentials}) =>
      _errorMapper.execute(
        () => _appleAuthDataSource.authenticate(
          AppleAuthRequestModel.fromAppleCredentials(credentials),
        ),
      );

  Future<AppleCredentialModel> getUsersAppleCredential() async {
    final credential =
        await _appleCredentialDataSource.getUsersAppleCredential();
    return AppleCredentialModel.fromAppleId(credential);
  }
}
