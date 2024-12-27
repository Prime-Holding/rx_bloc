import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/shimmer.dart';
import 'package:widget_toolkit/ui_components.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../blocs/onboarding_phone_confirm_bloc.dart';

/// Onboarding page where the user can confirm their phone number by entering a sms code.
class OnboardingPhoneConfirmPage extends StatefulWidget {
  const OnboardingPhoneConfirmPage({super.key});

  @override
  State<OnboardingPhoneConfirmPage> createState() =>
      _OnboardingPhoneConfirmPageState();
}

class _OnboardingPhoneConfirmPageState
    extends State<OnboardingPhoneConfirmPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(
          context,
          actions: [
            GestureDetector(
              onTap: () => showBlurredBottomSheet(
                context: context,
                builder: (context) => Text(
                  context.l10n.featureOnboarding.confirmPhoneFieldHint,
                  style: context.designSystem.typography.h2Reg16.copyWith(
                    color: context.designSystem.colors.gray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: context.designSystem.spacing.m),
                child: Icon(
                  Icons.info_outline,
                  color: context.designSystem.colors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SmsCodeProvider(
            sentNewCodeActivationTime: 2,
            smsCodeService: context.read<SmsCodeService>(),
            onResult: _onCodeResult,
            builder: (codeState) => Padding(
              padding: EdgeInsets.all(context.designSystem.spacing.l),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(height: context.designSystem.spacing.xxl),
                      Icon(
                        context.designSystem.icons.phoneConfirm,
                        size: context.designSystem.spacing.xxxxl3,
                      ),
                      SizedBox(height: context.designSystem.spacing.s),
                      Text(
                        context.l10n.featureOnboarding.phoneNumberConfirmTitle,
                        style: context.designSystem.typography.h1Med32,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.designSystem.spacing.xs),
                      Text(
                        context.l10n.featureOnboarding
                            .phoneNumberConfirmDescription,
                        style: context.designSystem.typography.h2Reg16,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.designSystem.spacing.l),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: context.designSystem.spacing.xs,
                        ),
                        child: ShimmerWrapper(
                          showShimmer: codeState == TemporaryCodeState.loading,
                          alignment: Alignment.center,
                          child: SmsCodeField(
                            controller: _controller,
                          ),
                        ),
                      ),
                      const ValidityWidget(),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: context.designSystem.spacing.xxxxl21,
                        child: Column(
                          children: [
                            ResendCodeButton(
                              activeStateIcon: Icon(
                                context.designSystem.icons.send,
                                color: context.designSystem.colors.primaryColor,
                              ),
                              pressedStateIcon: Icon(
                                context.designSystem.icons.success,
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
