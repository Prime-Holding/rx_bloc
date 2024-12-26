{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../blocs/onboarding_bloc.dart';
import '../ui_components/register_form.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => RxUnfocuser(
        child: Scaffold(
          appBar: customAppBar(context),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.designSystem.spacing.xxl,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppErrorModalWidget<OnboardingBlocType>(
                      errorState: (bloc) => bloc.states.errors,
                    ),
                    AppErrorModalWidget<OnboardingBlocType>(
                      errorState: (bloc) => bloc.states.resumeOnboardingErrors,
                      onRetry: (_, __) => context
                          .read<OnboardingBlocType>()
                          .events
                          .resumeOnboarding(),
                    ),
                    SizedBox(height: context.designSystem.spacing.xxl),
                    Icon(
                      context.designSystem.icons.avatar,
                      size: context.designSystem.spacing.xxxxl3,
                    ),
                    SizedBox(height: context.designSystem.spacing.s),
                    Text(
                      context.l10n.featureOnboarding.registerPageTitle,
                      style: context.designSystem.typography.h1Med32,
                    ),
                    SizedBox(height: context.designSystem.spacing.xs),
                    Text(
                      context.l10n.featureOnboarding.registerCredentialsHint,
                      style: context.designSystem.typography.h2Reg16,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.designSystem.spacing.l),
                    RegisterForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
