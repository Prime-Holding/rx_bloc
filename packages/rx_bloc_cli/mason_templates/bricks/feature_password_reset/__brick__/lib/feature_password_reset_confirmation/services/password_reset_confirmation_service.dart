{{> licence.dart }}

import '../../base/repositories/url_launcher_repository.dart';

/// Fake deep link for successful email confirmation.
/// Used for demo purposes, should be removed in a real app
String mockEmailDeepLinkSuccess(String email) =>
    '{{project_name}}://{{project_name}}/login/password-reset?token=$email&email=$email';

/// Fake deep link for unsuccessful email confirmation.
/// Used for demo purposes, should be removed in a real app
String mockEmailDeepLinkError(String email) =>
    '{{project_name}}://{{project_name}}/login/password-reset?token=00000000&email=$email';

class PasswordResetConfirmationService {
  PasswordResetConfirmationService(this._urlLauncherRepository);

  final UrlLauncherRepository _urlLauncherRepository;

  /// Opens the fake deep link for successful email confirmation.
  /// Used for demo purposes, should be removed in a real app
  Future<void> openMockEmailSuccessLink(String email) =>
      _urlLauncherRepository.openUri(mockEmailDeepLinkSuccess(email));

  /// Opens fake deep link for unsuccessful email confirmation.
  /// Used for demo purposes, should be removed in a real app
  Future<void> openMockEmailErrorLink(String email) =>
      _urlLauncherRepository.openUri(mockEmailDeepLinkError(email));
}
