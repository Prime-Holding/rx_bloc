/// Auth Configuration
class AuthConfiguration {
  /// AuthConfiguration constructor
  AuthConfiguration({
    required this.loginEnabled,
    required this.socialLoginsEnabled,
    required this.otpEnabled,
    required this.pinCodeEnabled,
  });

  /// Login with email enabled
  final bool loginEnabled;

  /// Social logins enabled
  final bool socialLoginsEnabled;

  /// OTP authentication enabled
  final bool otpEnabled;

  /// Pin Code authentication enabled
  final bool pinCodeEnabled;

  /// Authentication enabled
  bool get authenticationEnabled =>
      loginEnabled || socialLoginsEnabled || otpEnabled || pinCodeEnabled;
}
