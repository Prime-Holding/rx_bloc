{{> licence.dart }}

import '../../lib_auth/models/auth_token_model.dart';
import '../repositories/facebook_auth_repository.dart';
import 'social_login_service.dart';

class FacebookAuthService extends SocialLoginService {
  FacebookAuthService(
    this._facebookAuthRepository,
    super.userAccountService,
  );

  final FacebookAuthRepository _facebookAuthRepository;

  @override
  Future<AuthTokenModel> authenticate() async {
    final credential =
        await _facebookAuthRepository.getUserFacebookCredentials();

    return await _facebookAuthRepository.facebookAuth(requestModel: credential);
  }
}
