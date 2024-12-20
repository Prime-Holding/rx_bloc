import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../base/common_services/users_service.dart';

/// Service used to implement SMS code logic
class OnboardingPhoneSmsCodeService implements SmsCodeService {
  OnboardingPhoneSmsCodeService(this._usersService);

  final UsersService _usersService;

  /// Confirm if the entered code is equal to the last send code
  @override
  Future<dynamic> confirmPhoneCode(String code) async {
    final confirmResponse = await _usersService.confirmPhoneNumber(code);

    /// TODO: Implement sms code confirmation logic

    /// Return mock response to validate the code
    return confirmResponse;
  }

  /// Get user's phone number with the country code
  @override
  Future<String> getFullPhoneNumber() async => '';

  /// Edit the user's phone number and return fullPhoneNumber
  @override
  Future<String> updatePhoneNumber(String newNumber) async => newNumber;

  /// Send a new code to the user
  @override
  Future<bool> sendConfirmationSms(String usersPhoneNumber) async {
    await _usersService.resendSmsCode();
    return true;
  }

  /// How long codes will be valid in seconds
  @override
  Future<int> getValidityTime(bool reset) async => 30;

  /// How long the resendCode button will be disabled after a code has been sent
  @override
  Future<int> getResendButtonThrottleTime(bool reset) async => 15;

  /// How many characters the code has
  @override
  Future<int> getCodeLength() async => 4;
}
