{{> licence.dart }}

import '../../lib_auth/models/auth_token_model.dart';
import '../../lib_auth/services/user_account_service.dart';
import '../repositories/facebook_auth_repository.dart';
import 'social_login_service.dart';

class FacebookAuthService extends SocialLoginService {
FacebookAuthService(
UserAccountService userAccountService,
this._facebookAuthRepository,
) : super(userAccountService);

final FacebookAuthRepository _facebookAuthRepository;

@override
Future<AuthTokenModel?> authenticate() async {
try {
final credential =
await _facebookAuthRepository.getUserFacebookCredentials();

if (credential != null) {
return await _facebookAuthRepository.facebookAuth(
requestModel: credential);
} else {
return null;
}
} catch (e) {
print(e);
return null;
}
}
}
