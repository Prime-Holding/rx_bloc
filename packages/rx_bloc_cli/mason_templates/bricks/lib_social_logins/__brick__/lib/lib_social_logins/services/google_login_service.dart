{{> licence.dart }}

import '../../lib_auth/models/auth_token_model.dart';
import '../repositories/google_auth_repository.dart';
import 'social_login_service.dart';

class GoogleLoginService extends SocialLoginService {
  GoogleLoginService(
    this._googleAuthRepository,
    super.userAccountService,
  );

  final GoogleAuthRepository _googleAuthRepository;

  @override
  Future<AuthTokenModel> authenticate() async {
    final googleUser = await _googleAuthRepository.getUsersGoogleCredential();

    return _googleAuthRepository.googleAuth(googleAuthRequestModel: googleUser);
  }
}
