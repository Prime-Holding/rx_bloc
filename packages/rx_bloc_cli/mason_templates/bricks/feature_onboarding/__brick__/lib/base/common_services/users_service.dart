import '../models/user_model.dart';
import '../models/user_with_auth_token_model.dart';
import '../repositories/url_launcher_repository.dart';
import '../repositories/users_repository.dart';

const mockEmailDeepLinkError =
    '{{project_name}}://{{project_name}}/onboarding/email-confirmed/00000000';
const mockEmailDeepLinkSuccess =
    '{{project_name}}://{{project_name}}/onboarding/email-confirmed/11111111';

class UsersService {
  UsersService(
    this._usersRepository,
    this._urlLauncherRepository,
  );

  final UsersRepository _usersRepository;
  final UrlLauncherRepository _urlLauncherRepository;

  Future<bool> isProfileTemporary() => _usersRepository.isProfileTemporary();

  Future<void> setIsProfileTemporary(bool isProfileTemporary) =>
      _usersRepository.setIsProfileTemporary(isProfileTemporary);

  Future<UserWithAuthTokenModel> register({
    required String email,
    required String password,
  }) =>
      _usersRepository.register(email: email, password: password);

  Future<UserModel> getMyUser() => _usersRepository.getMyUser();

  Future<UserModel> resendConfirmationEmail() =>
      _usersRepository.resendConfirmationEmail();

  Future<UserModel> confirmEmail({
    required String token,
  }) =>
      _usersRepository.confirmEmail(token: token);

  Future<void> openMockEmailSuccessLink() =>
      _urlLauncherRepository.openUri(mockEmailDeepLinkSuccess);

  Future<void> openMockEmailErrorLink() =>
      _urlLauncherRepository.openUri(mockEmailDeepLinkError);
}
