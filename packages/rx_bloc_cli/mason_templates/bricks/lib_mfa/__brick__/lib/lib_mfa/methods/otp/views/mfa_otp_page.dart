{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:widget_toolkit/widget_toolkit.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../../../app_extensions.dart';
import '../../../../feature_otp/services/otp_text_field_validator.dart';
import '../../../extensions/exception_extensions.dart';
import '../../../models/mfa_response.dart';
import '../services/mfa_otp_service.dart';

class MfaOtpPage extends StatelessWidget {
  const MfaOtpPage({
    required this.transactionId,
    super.key,
  });

  final String transactionId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureOtp.otpPageTitle),
        ),
        body: SafeArea(
          child: SmsCodeProvider(
            onError: (context, error) {
              if (error != null && !error.isAuthMethodException) {
                GoRouter.of(context).pop(Result<MfaResponse>.error(error));
              }
            },
            onResult: (context, result) {
              if (result is MfaResponse) {
                GoRouter.of(context).pop(Result<MfaResponse>.success(result));
              }
            },
            sentNewCodeActivationTime: 2,
            smsCodeService: context.read<MfaOtpService>(),
            builder: (state) => Padding(
              padding: EdgeInsets.all(context.designSystem.spacing.l),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmsPhoneNumberField(
                    builder: (context, number, onChanged) => TextFieldDialog(
                      label: context.l10n.featureOtp.phoneNumber,
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
                        style:TextStyle(
                          color: context.designSystem.colors.tintColor,
                        ),
                      ),
                      SizedBox(height: context.designSystem.spacing.xs),
                      const SmsCodeField(),
                      SizedBox(height: context.designSystem.spacing.xs),
                      const ValidityWidget(),
                    ],
                  ),
                  SizedBox(
                    height: context.designSystem.spacing.xxxxl21,
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
