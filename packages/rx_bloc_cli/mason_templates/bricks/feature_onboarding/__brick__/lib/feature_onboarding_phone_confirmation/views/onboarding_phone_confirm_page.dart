import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../blocs/onboarding_phone_confirm_bloc.dart';

/// Onboarding page where the user can confirm their phone number by entering a sms code.
class OnboardingPhoneConfirmPage extends StatelessWidget {
  const OnboardingPhoneConfirmPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SmsCodeProvider(
            sentNewCodeActivationTime: 2,
            smsCodeService: context.read<SmsCodeService>(),
            onResult: _onCodeResult,
            builder: (state) => Padding(
              padding: EdgeInsets.all(context.designSystem.spacing.l),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      context
                          .l10n.featureOnboarding.phoneNumberConfirmationHeader,
                      style: context.designSystem.typography.h1Reg20,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        context.l10n.featureOnboarding.confirmPhoneFieldHint,
                        style: context.designSystem.typography.h2Reg16.copyWith(
                          color: context.designSystem.colors.gray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: context.designSystem.spacing.xs,
                        ),
                        child: const SmsCodeField(),
                      ),
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
                  AppErrorModalWidget<OnboardingPhoneConfirmBlocType>(
                    errorState: (bloc) => bloc.states.errors,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _onCodeResult(BuildContext context, dynamic result) {
    FocusManager.instance.primaryFocus?.unfocus();
    context
        .read<OnboardingPhoneConfirmBlocType>()
        .events
        .setConfirmationResult(result);
  }
}
