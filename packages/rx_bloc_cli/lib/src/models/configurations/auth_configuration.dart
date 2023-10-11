/// Auth Configuration
class AuthConfiguration {
  /// AuthConfiguration constructor
  AuthConfiguration({
    required this.loginEnabled,
    required this.socialLoginsEnabled,
    required this.otpEnabled,
    required this.pinCodeEnabled,
    required this.authMatrixEnabled,
  });

  /// Login with email enabled
  final bool loginEnabled;

  /// Social logins enabled
  final bool socialLoginsEnabled;

  /// OTP authentication enabled
  final bool otpEnabled;

  /// Pin Code authentication enabled
  final bool pinCodeEnabled;

  /// Auth Matrix enabled
  final bool authMatrixEnabled;

  /// Authentication enabled
  bool get authenticationEnabled =>
      loginEnabled ||
      socialLoginsEnabled ||
      otpEnabled ||
      pinCodeEnabled ||
      authMatrixEnabled;
}
