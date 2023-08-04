part of '../generator_arguments_provider.dart';

class _AuthConfigurationProvider {
  _AuthConfigurationProvider(this._reader, this._logger);

  final CommandArgumentsReader _reader;
  final Logger _logger;

  _AuthConfiguration read() {
    // Login
    var loginEnabled = _reader.read<bool>(CommandArguments.login);

    // Social Logins
    final socialLoginsEnabled =
        _reader.read<bool>(CommandArguments.socialLogins);

    // OTP
    final otpEnabled = _reader.read<bool>(CommandArguments.otp);

    if (otpEnabled && !(loginEnabled || socialLoginsEnabled)) {
      // Modify feature or throw exception
      _logger.warn('Login enabled, due to OTP feature requirement');
      loginEnabled = true;
    }

    return _AuthConfiguration(
      loginEnabled: loginEnabled,
      socialLoginsEnabled: socialLoginsEnabled,
      otpEnabled: otpEnabled,
    );
  }
}

class _AuthConfiguration {
  _AuthConfiguration({
    required this.loginEnabled,
    required this.socialLoginsEnabled,
    required this.otpEnabled,
  });

  final bool loginEnabled;
  final bool socialLoginsEnabled;
  final bool otpEnabled;

  bool get authenticationEnabled =>
      loginEnabled || socialLoginsEnabled || otpEnabled;
}
