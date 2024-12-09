import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/text_field_dialog.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../app_extensions.dart';
import '../services/custom_sms_code_service.dart';
import '../services/otp_text_field_validator.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({
    this.otpLabel,
    this.appBar,
    this.header,
    this.otpService,
    this.onResult,
    this.contentAlignment = MainAxisAlignment.spaceBetween,
    super.key,
  });

  /// The app bar that will be displayed at the top of the screen.
  final PreferredSizeWidget? appBar;

  /// The header widget that will be displayed above the otp input field.
  final Widget? header;

  /// Widget that will be displayed just above the otp input field
  /// and below the [header].
  final Widget? otpLabel;

  /// The service that will be used to send and validate the otp code.
  /// If none is provided, a lookup at the widget tree will be performed.
  final SmsCodeService? otpService;

  /// Callback that will be called when the otp code is validated.
  final void Function(BuildContext, dynamic)? onResult;

  /// The alignment of the content inside the widget.
  final MainAxisAlignment contentAlignment;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: SmsCodeProvider(
            sentNewCodeActivationTime: 2,
            smsCodeService: otpService ?? context.read<SmsCodeService>(),
            onResult: onResult,
            builder: (state) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: contentAlignment,
                children: [
                  header ?? const SizedBox.shrink(),
                  Column(
                    children: [
                      if (otpLabel != null) otpLabel!,
                      const SizedBox(height: 8),
                      const SmsCodeField(
                        key: K.otpInput,
                      ),
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
