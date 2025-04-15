import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../base/common_blocs/coordinator_bloc.dart';

/// Service used to implement SMS code logic
class CustomSmsCodeService implements SmsCodeService {
  const CustomSmsCodeService();

  /// Confirm if the entered code is equal to the last send code
  @override
  Future<dynamic> confirmPhoneCode(String code) async {
    if (code == '0000') {
      return true;
    }
    throw Exception();
  }

  /// Get user's phone number with the country code
  @override
  Future<String> getFullPhoneNumber() async => '+38164 1234567';

  /// Edit the user's phone number and return fullPhoneNumber
  @override
  Future<String> updatePhoneNumber(String newNumber) async => '+38164 1234567';

  /// Send a new code to the user
  @override
  Future<bool> sendConfirmationSms(String usersPhoneNumber) async {
    await Future.delayed(const Duration(seconds: 3));
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
