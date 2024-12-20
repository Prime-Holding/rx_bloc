import '../models/user_model.dart';
import '../models/user_with_auth_token_model.dart';
import '../repositories/url_launcher_repository.dart';
import '../repositories/users_repository.dart';

/// Fake deep link for successful email confirmation.
/// Used for demo purposes, should be removed in a real app
const mockEmailDeepLinkError =
    '{{project_name}}://{{project_name}}/onboarding/email-confirmed/00000000';

/// Fake deep link for unsuccessful email confirmation.
/// Used for demo purposes, should be removed in a real app
const mockEmailDeepLinkSuccess =
    '{{project_name}}://{{project_name}}/onboarding/email-confirmed/11111111';

class OnboardingService {
  OnboardingService(
    this._usersRepository,
    this._urlLauncherRepository,
  );

  final UsersRepository _usersRepository;
  final UrlLauncherRepository _urlLauncherRepository;

  /// Starts the onboarding for a new user with the given [email] and [password].
  /// Returns the [UserModel] with the email and temporary profile, as well as
  /// their access token
  Future<UserWithAuthTokenModel> register({
    required String email,
    required String password,
  }) =>
      _usersRepository.register(email: email, password: password);

  /// Gets the existing user. Currently used to resume onboarding
  Future<UserModel> getMyUser() => _usersRepository.getMyUser();

  /// Resends the confirmation email to the user
  Future<UserModel> resendConfirmationEmail() =>
      _usersRepository.resendConfirmationEmail();

  /// Confirms the email of the user with the given [token].
  /// Returns the [UserModel] with the confirmed email
  Future<UserModel> confirmEmail({
    required String token,
  }) =>
      _usersRepository.confirmEmail(token: token);

  /// Opens the fake deep link for successful email confirmation.
  /// Used for demo purposes, should be removed in a real app
  Future<void> openMockEmailSuccessLink() =>
      _urlLauncherRepository.openUri(mockEmailDeepLinkSuccess);

  /// Opens fake deep link for unsuccessful email confirmation.
  /// Used for demo purposes, should be removed in a real app
  Future<void> openMockEmailErrorLink() =>
      _urlLauncherRepository.openUri(mockEmailDeepLinkError);

  /// Sets the phone number for the user
  Future<UserModel> submitPhoneNumber(String phoneNumber) =>
      _usersRepository.submitPhoneNumber(phoneNumber);

  /// Confirms a previously submitted phone number by providing the SMS code
  /// sent to the same number
  Future<UserModel> confirmPhoneNumber(String smsCode) =>
      _usersRepository.confirmPhoneNumber(smsCode);

  /// Resends the SMS code to the user's phone number
  Future<void> resendSmsCode() => _usersRepository.resendSmsCode();
}
