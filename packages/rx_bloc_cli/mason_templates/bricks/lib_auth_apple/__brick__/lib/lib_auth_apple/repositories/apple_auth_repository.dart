{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../lib_auth/models/auth_token_model.dart';
import '../data_sources/apple_auth_data_source.dart';
import '../models/apple_auth_request_model.dart';
import '../models/apple_credentials_model.dart';

class AppleAuthRepository {
  AppleAuthRepository(
    this._errorMapper,
    this._appleAuthDataSource,
  );

  final ErrorMapper _errorMapper;
  final AppleAuthDataSource _appleAuthDataSource;

  Future<AuthTokenModel> authenticateWithApple(
          {required AppleCredentialsModel credentials}) =>
      _errorMapper.execute(
        () => _appleAuthDataSource.authenticate(
          AppleAuthRequestModel.fromAppleCredentials(credentials),
        ),
      );
}
