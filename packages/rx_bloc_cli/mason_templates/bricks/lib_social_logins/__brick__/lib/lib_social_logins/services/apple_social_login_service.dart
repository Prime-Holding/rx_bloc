{{> licence.dart }}

import '../../lib_auth/models/auth_token_model.dart';
import '../../lib_auth/services/user_account_service.dart';
import '../repositories/apple_auth_repository.dart';
import 'social_login_service.dart';

class AppleSocialLoginService extends SocialLoginService {
  AppleSocialLoginService(
      UserAccountService userAccountService, this._appleAuthRepository)
      : super(userAccountService);

  final AppleAuthRepository _appleAuthRepository;

  @override
  Future<AuthTokenModel?> authenticate() async {
    try {
      final credential = await _appleAuthRepository.getUsersAppleCredential();
      if (credential != null) {
        return await _appleAuthRepository.authenticateWithApple(
          credentials: credential,
        );
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
