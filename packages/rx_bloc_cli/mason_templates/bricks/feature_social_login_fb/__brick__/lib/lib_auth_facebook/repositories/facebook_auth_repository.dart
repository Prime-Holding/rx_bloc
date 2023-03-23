import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../lib_auth/models/auth_token_model.dart';
import '../data_sources/remote/facebook_auth_data_source.dart';
import '../models/facebook_auth_request_model.dart';

class FacebookAuthRepository {
  FacebookAuthRepository(this._authDataSource, this._errorMapper);
  final FacebookAuthDataSource _authDataSource;
  final ErrorMapper _errorMapper;

  Future<AuthTokenModel> facebookAuth(
      {required FacebookAuthRequestModel requestModel}) =>
      _errorMapper.execute(
            () => _authDataSource.facebookAuthenticate(
          FacebookAuthRequestModel(
            email: requestModel.email,
            facebookToken: requestModel.facebookToken,
            isAuthenticated: requestModel.isAuthenticated,
          ),
        ),
      );
}
