{{> licence.dart }}

import '../../lib_auth/models/auth_token_model.dart';
import '../repositories/apple_auth_repository.dart';
import 'social_login_service.dart';

class AppleSocialLoginService extends SocialLoginService {
  AppleSocialLoginService(
    this._appleAuthRepository,
    super.userAccountService,
  );

  final AppleAuthRepository _appleAuthRepository;

  @override
  Future<AuthTokenModel> authenticate() async {
    final credential = await _appleAuthRepository.getUsersAppleCredential();
    return await _appleAuthRepository.authenticateWithApple(
      credentials: credential,
    );
  }
}
