{{> licence.dart }}

import '../models/user_model.dart';
import '../repositories/register_repository.dart';
import '../repositories/url_launcher_repository.dart';
import '../repositories/users_repository.dart';
import 'onboarding_service.dart';

/// Fake deep link for successful email confirmation.
/// Used for demo purposes, should be removed in a real app
const mockEmailDeepLinkSuccess =
    'testapp://testapp/change-email/email-confirmed/11111111';
const mockEmailDeepLinkError =
    'testapp://testapp/change-email/email-confirmed/00000000';

class EmailChangeService extends OnboardingService {
  EmailChangeService(
    this._usersRepository,
    this._urlLauncherRepository,
    RegisterRepository _registerRepository,
  ) : super(_usersRepository, _registerRepository, _urlLauncherRepository);

  final UsersRepository _usersRepository;
  final UrlLauncherRepository _urlLauncherRepository;

  /// Gets the existing user. Currently used to resume onboarding
  @override
  Future<UserModel> getMyUser() => _usersRepository.getMyUser();

  /// Resends the confirmation email to the user
  @override
  Future<UserModel> resendConfirmationEmail() =>
      _usersRepository.resendConfirmationEmail();

  /// Confirms the email of the user with the given [token].
  /// Returns the [UserModel] with the confirmed email
  @override
  Future<UserModel> confirmEmail({
    required String token,
  }) =>
      _usersRepository.confirmEmail(token);

  /// Opens the fake deep link for successful email confirmation.
  /// Used for demo purposes, should be removed in a real app
  @override
  Future<void> openMockEmailSuccessLink() =>
      _urlLauncherRepository.openUri(mockEmailDeepLinkSuccess);

  /// Opens fake deep link for unsuccessful email confirmation.
  /// Used for demo purposes, should be removed in a real app
  @override
  Future<void> openMockEmailErrorLink() =>
      _urlLauncherRepository.openUri(mockEmailDeepLinkError);
}
