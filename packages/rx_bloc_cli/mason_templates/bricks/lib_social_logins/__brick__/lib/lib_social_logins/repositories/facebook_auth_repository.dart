{{> licence.dart}}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../lib_auth/models/auth_token_model.dart';
import '../data_sources/facebook_auth_data_source.dart';
import '../data_sources/facebook_credential_data_source.dart';
import '../models/facebook_auth_request_model.dart';

class FacebookAuthRepository {
  FacebookAuthRepository(
      this._fbAuthDataSource, this._errorMapper, this._credentialDataSource);
  final FacebookAuthDataSource _fbAuthDataSource;
  final ErrorMapper _errorMapper;
  final FacebookCredentialDataSource _credentialDataSource;

  Future<AuthTokenModel> facebookAuth(
          {required FacebookAuthRequestModel requestModel}) =>
      _errorMapper.execute(
        () => _fbAuthDataSource.facebookAuthenticate(requestModel),
      );

  Future<FacebookAuthRequestModel?> getUserFacebookCredentials() async =>
      _errorMapper
          .execute(() => _credentialDataSource.getUsersFacebookCredential());
}
