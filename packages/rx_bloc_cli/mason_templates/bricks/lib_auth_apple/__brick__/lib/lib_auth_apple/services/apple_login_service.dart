{{> licence.dart }}

import '../../lib_auth/models/auth_token_model.dart';
import '../../lib_auth/services/social_login_service.dart';
import '../models/apple_credential_model.dart';
import '../repositories/apple_auth_repository.dart';

class AppleLoginService extends SocialLoginService {
  AppleLoginService(this._appleAuthRepository);

  final AppleAuthRepository _appleAuthRepository;

  @override
  Future<AuthTokenModel> getSocialAuthentication() async {
    final AppleCredentialModel credential =
        await _appleAuthRepository.getUsersAppleCredential();
    return _appleAuthRepository.authenticateWithApple(credentials: credential);
  }
}
