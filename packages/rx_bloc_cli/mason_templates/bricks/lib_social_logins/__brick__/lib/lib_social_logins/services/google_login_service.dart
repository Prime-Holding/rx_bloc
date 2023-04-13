{{> licence.dart }}

import '../../lib_auth/models/auth_token_model.dart';
import '../../lib_auth/services/user_account_service.dart';
import '../models/google_credentials_model.dart';
import '../repositories/google_auth_repository.dart';
import 'social_login_service.dart';

class GoogleLoginService extends SocialLoginService {
GoogleLoginService(
UserAccountService userAccountService, this._googleAuthRepository)
    : super(userAccountService);
final GoogleAuthRepository _googleAuthRepository;

@override
Future<AuthTokenModel?> authenticate() async {
try {
final GoogleCredentialsModel? googleUser =
await _googleAuthRepository.getUsersGoogleCredential();
if (googleUser != null) {
return _googleAuthRepository.googleAuth(
googleAuthRequestModel: googleUser);
} else {
return null;
}
} catch (e) {
print(e);
return null;
}
}
}
