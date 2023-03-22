import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../lib_auth/data_sources/remote/auth_data_source.dart';
import '../../lib_auth/models/auth_token_model.dart';
import '../models/request_models/google_auth_request_model.dart';

class GoogleAuthRepository {
  GoogleAuthRepository(this._authDataSource, this._errorMapper);
  final AuthDataSource _authDataSource;
  final ErrorMapper _errorMapper;

  Future<AuthTokenModel> googleAuth(
          {String? email, String? token, String? refreshToken}) =>
      _errorMapper.execute(
        () => _authDataSource.googleAuth(
          GoogleAuthRequestModel(
            email: email,
            token: token,
            refreshToken: refreshToken,
          ),
        ),
      );
}
