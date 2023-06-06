import 'package:flutter/material.dart';
import 'package:widget_toolkit/text_field_dialog.dart';

import '../../app_extensions.dart';
import '../lib_sms_code_field/sms_code_field.dart';
import '../lib_sms_code_verification/di/sms_code_provider.dart';
import '../lib_sms_code_verification/services/sms_code_service.dart';
import '../lib_sms_code_verification/ui_components/resend_button_timer.dart';
import '../lib_sms_code_verification/ui_components/resend_code_button.dart';
import '../lib_sms_code_verification/ui_components/sms_phone_number_field.dart';
import '../lib_sms_code_verification/ui_components/validity_widget.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureOtp.otpPageTitle),
        ),
        body: SafeArea(
          child: SmsCodeProvider(
            sentNewCodeActivationTime: 2,
            smsCodeService: _FakeSmsCodeService(),
            builder: (state) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmsPhoneNumberField(
                    builder: (context, number, onChanged) => TextFieldDialog(
                      label: context.l10n.featureOtp.phoneNumber,
                      value: number,
                      validator: _FakeTextFieldValidator(),
                      translateError: (Object error) => null,
                      onChanged: onChanged,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        context.l10n.featureOtp.hint,
                        style:
                            TextStyle(color: context.designSystem.colors.gray),
                      ),
                      const SizedBox(height: 8),
                      const SmsCodeField(),
                      const SizedBox(height: 8),
                      const ValidityWidget(),
                    ],
                  ),
                  SizedBox(
                    height: 85,
                    child: Column(
                      children: [
                        ResendCodeButton(
                          activeStateIcon: Icon(
                            Icons.send,
                            color: context.designSystem.colors.primaryColor,
                          ),
                          pressedStateIcon: Icon(
                            Icons.check_circle_outline,
                            color: context
                                .designSystem.colors.pinSuccessBorderColor,
                          ),
                        ),
                        const ResendButtonTimer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _FakeTextFieldValidator extends TextFieldValidator<String> {
  @override
  Future<String> validateOnSubmit(String text) async => text;

  @override
  void validateOnType(String text) => true;
}

/// Service used to implement SMS code logic
class _FakeSmsCodeService implements SmsCodeService {
  /// Confirm if the entered code is equal to the last send code
  @override
  Future<dynamic> confirmPhoneCode(String code) async {
    return code == '0000' ? true : throw Exception();
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
