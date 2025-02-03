{{> licence.dart }}

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import 'onboarding_phone_sms_code_service_mock.mocks.dart';

@GenerateMocks([SmsCodeService])
SmsCodeService createSmsCodeService() {
  final mockCreatePinCodeService = MockSmsCodeService();

  when(mockCreatePinCodeService.getCodeLength()).thenAnswer((_) async => 4);

  when(mockCreatePinCodeService.confirmPhoneCode(any))
      .thenAnswer((_) async => true);

  when(mockCreatePinCodeService.getFullPhoneNumber())
      .thenAnswer((_) async => '1234567890');

  when(mockCreatePinCodeService.updatePhoneNumber(any))
      .thenAnswer((_) async => '0987654321');

  when(mockCreatePinCodeService.sendConfirmationSms(any))
      .thenAnswer((_) async => false);

  when(mockCreatePinCodeService.getValidityTime(any))
      .thenAnswer((_) async => 15);

  when(mockCreatePinCodeService.getResendButtonThrottleTime(any))
      .thenAnswer((_) async => 10);

  return mockCreatePinCodeService;
}
