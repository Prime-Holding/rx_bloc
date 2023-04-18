{{> licence.dart }}

import '../../lib_auth/models/auth_token_model.dart';
import '../../lib_auth/services/user_account_service.dart';

abstract class SocialLoginService {
  SocialLoginService(this._userAccountService);

  final UserAccountService _userAccountService;

  Future<AuthTokenModel> authenticate();

  Future<AuthTokenModel> login() async {
    final authToken = await authenticate();
      // Save response tokens
      await _userAccountService.saveTokens(authToken);

      // Subscribe user push token
      await _userAccountService.subscribeForNotifications();

      // Load permissions
      await _userAccountService.loadPermissions();

      return authToken;
    }
  }

