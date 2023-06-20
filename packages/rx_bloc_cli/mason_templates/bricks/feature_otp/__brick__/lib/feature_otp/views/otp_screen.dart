import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/text_field_dialog.dart';
import 'package:widget_toolkit/theme_data.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../app_extensions.dart';
import '../services/custom_sms_code_service.dart';
import '../services/otp_text_field_validator.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = context.l10n.featureOtp.phoneNumber;
    return MaterialApp(
      theme: ThemeData.light()
          .copyWith(colorScheme: ColorScheme.fromSwatch(), extensions: [
        WidgetToolkitTheme.light,
        SmsCodeTheme.light,
        TextFieldDialogTheme.light,
      ]),
      darkTheme: ThemeData.dark()
          .copyWith(colorScheme: ColorScheme.fromSwatch(), extensions: [
        WidgetToolkitTheme.dark,
        SmsCodeTheme.dark,
        TextFieldDialogTheme.dark,
      ]),
      home: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureOtp.otpPageTitle),
        ),
        body: SafeArea(
          child: SmsCodeProvider(
            sentNewCodeActivationTime: 2,
            smsCodeService: CustomSmsCodeService(context.read()),
            builder: (state) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmsPhoneNumberField(
                    builder: (context, number, onChanged) => TextFieldDialog(
                      label: phoneNumber,
                      value: number,
                      validator: OtpTextFieldValidator(),
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
      ),
    );
  }
}
