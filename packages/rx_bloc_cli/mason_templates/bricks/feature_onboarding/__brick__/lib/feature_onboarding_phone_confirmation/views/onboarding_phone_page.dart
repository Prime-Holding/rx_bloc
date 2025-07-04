{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../blocs/onboarding_phone_bloc.dart';
import '../ui_components/phone_number_form.dart';

/// Onboarding page where the user can enter their phone number.
class OnboardingPhonePage extends StatelessWidget {
  const OnboardingPhonePage({super.key});

  @override
  Widget build(BuildContext context) => RxForceUnfocuser(
        child: RxUnfocuser(
          child: Scaffold(
            appBar: customAppBar(context),
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.designSystem.spacing.xs1,
                horizontal: context.designSystem.spacing.xxxxl,
              ),
              child: Center(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: context.designSystem.spacing.xxl),
                          Icon(
                            context.designSystem.icons.phone,
                            size: context.designSystem.spacing.xxxxl3,
                          ),
                          SizedBox(height: context.designSystem.spacing.s),
                          Text(
                            context.l10n.featureOnboarding.phoneNumberTitle,
                            textAlign: TextAlign.center,
                            style: context.designSystem.typography.h1Med32,
                          ),
                          SizedBox(height: context.designSystem.spacing.xs),
                          Text(
                            context
                                .l10n.featureOnboarding.phoneNumberDescription,
                            textAlign: TextAlign.center,
                            style: context.designSystem.typography.h2Reg16,
                          ),
                          SizedBox(height: context.designSystem.spacing.l),
                        ],
                      ),
                      const PhoneNumberForm(),
                      AppErrorModalWidget<OnboardingPhoneBlocType>(
                        errorState: (bloc) => bloc.states.errors,
                      ),
                      AnimatedPadding(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.only(
                          top: context.designSystem.spacing.xxl,
                          bottom: context.designSystem.spacing.xxl,
                        ),
                        child: RxBlocBuilder<OnboardingPhoneBlocType, bool>(
                          state: (bloc) => bloc.states.isLoading,
                          builder: (context, loadingSnapshot, bloc) {
                            final loading = loadingSnapshot.data ?? false;
                            return GradientFillButton(
                              text: context.l10n.featureOnboarding.continueText,
                              state: loading
                                  ? ButtonStateModel.loading
                                  : ButtonStateModel.enabled,
                              onPressed: !loading
                                  ? () => context
                                      .read<OnboardingPhoneBlocType>()
                                      .events
                                      .submitPhoneNumber()
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
