import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../blocs/onboarding_phone_bloc.dart';
import '../ui_components/phone_number_form.dart';

/// Onboarding page where the user can enter their phone number.
class OnboardingPhonePage extends StatelessWidget {
  const OnboardingPhonePage({super.key});

  @override
  Widget build(BuildContext context) => RxForceUnfocuser(
        child: RxUnfocuser(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.designSystem.spacing.xs1,
                horizontal: context.designSystem.spacing.xxxxl,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        context.l10n.featureOnboarding.enterPhoneNumber,
                        style: context.designSystem.typography.h1Reg20,
                      ),
                      SizedBox(height: context.designSystem.spacing.xxxxl),
                      const PhoneNumberForm(),
                    ],
                  ),
                  Column(
                    children: [
                      RxBlocMultiBuilder2<OnboardingPhoneBlocType, bool, bool>(
                        state1: (bloc) => bloc.states.submitPhoneNumberEnabled,
                        state2: (bloc) => bloc.states.isLoading,
                        builder:
                            (context, enabledSnapshot, loadingSnapshot, bloc) {
                          final enabled = enabledSnapshot.data ?? false;
                          final loading = loadingSnapshot.data ?? false;
                          return GradientFillButton(
                            text: context.l10n.featureOnboarding.continueText,
                            state: enabled
                                ? (loading
                                    ? ButtonStateModel.loading
                                    : ButtonStateModel.enabled)
                                : ButtonStateModel.disabled,
                            onPressed: enabled && !loading
                                ? () => context
                                    .read<OnboardingPhoneBlocType>()
                                    .events
                                    .submitPhoneNumber()
                                : null,
                          );
                        },
                      ),
                      AppErrorModalWidget<OnboardingPhoneBlocType>(
                        errorState: (bloc) => bloc.states.errors,
                      ),
                      RxBlocListener<OnboardingPhoneBlocType, bool>(
                        state: (bloc) => bloc.states.phoneSubmitted,
                        listener: (context, success) => context
                            .read<RouterBlocType>()
                            .events
                            .push(const OnboardingPhoneConfirmRoute()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
