import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_auth/models/auth_token_model.dart';
import '../data_sources/remote/google_auth_data_source.dart';
import '../data_sources/remote/google_credential_data_source.dart';
import '../models/google_auth_request_model.dart';

class GoogleAuthRepository {
  GoogleAuthRepository(this._googleAuthDataSource, this._errorMapper,
      this._googleCredentialDataSource);
  final GoogleAuthDataSource _googleAuthDataSource;
  final ErrorMapper _errorMapper;
  final GoogleCredentialDataSource _googleCredentialDataSource;

  Future<AuthTokenModel> googleAuth({
    GoogleAuthRequestModel? googleAuthRequestModel,
  }) =>
      _errorMapper.execute(
        () => _googleAuthDataSource.googleAuth(googleAuthRequestModel!),
      );

  Future<GoogleAuthRequestModel> getUsersGoogleCredential() async {
    final googleUser =
        await _googleCredentialDataSource.getUsersGoogleCredential();
    if (googleUser == null) {
      throw GenericErrorModel('Google login failed');
    }
    return GoogleAuthRequestModel(
      email: googleUser.email,
      id: googleUser.id,
      serverAuthCode: googleUser.serverAuthCode,
      displayName: googleUser.displayName,
      photoUrl: googleUser.photoUrl,
    );
  }
}
