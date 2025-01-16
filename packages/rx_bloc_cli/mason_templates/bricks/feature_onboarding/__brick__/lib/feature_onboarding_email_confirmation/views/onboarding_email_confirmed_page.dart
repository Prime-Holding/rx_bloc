{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/shimmer.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/onboarding_email_confirmed_bloc.dart';

class OnboardingEmailConfirmedPage extends StatelessWidget {
  final String? verifyEmail;

  const OnboardingEmailConfirmedPage({
    this.verifyEmail,
    super.key,
  });

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: RxBlocBuilder<OnboardingEmailConfirmedBlocType, bool>(
          state: (bloc) => bloc.states.isLoading,
          builder: (context, loading, bloc) => Scaffold(
            appBar: customAppBar(context),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  context.designSystem.spacing.l,
                  0,
                  context.designSystem.spacing.l,
                  context.designSystem.spacing.m,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppErrorModalWidget<OnboardingEmailConfirmedBlocType>(
                      errorState: (bloc) => bloc.states.errors,
                      onRetry: (_, __) => bloc.events.verifyEmail(),
                      onCancel: () => bloc.events.goToLogin(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Icon(loading: loading.isLoading),
                            SizedBox(height: context.designSystem.spacing.l),
                            ShimmerText(
                              loading.isLoading
                                  ? null
                                  : context.l10n.featureOnboarding
                                      .titleEmailConfirmed,
                              style: context.designSystem.typography.h1Med32,
                              textAlign: TextAlign.center,
                              alignment: Alignment.center,
                            ),
                            SizedBox(height: context.designSystem.spacing.xs),
                            ShimmerText(
                              loading.isLoading
                                  ? null
                                  : context.l10n.featureOnboarding
                                      .titleEmailConfirmedDescription,
                              textAlign: TextAlign.center,
                              alignment: Alignment.center,
                              style: context.designSystem.typography.h2Reg16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GradientFillButton(
                      areIconsClose: true,
                      text: context.l10n.continueText,
                      state: loading.isLoading
                          ? ButtonStateModel.loading
                          : ButtonStateModel.enabled,
                      onPressed: loading.isLoading
                          ? null
                          : () => context
                              .read<OnboardingEmailConfirmedBlocType>()
                              .events
                              .goToPhonePage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _Icon extends StatelessWidget {
  const _Icon({
    required this.loading,
  });

  final bool loading;

  @override
  Widget build(BuildContext context) => ShimmerWrapper(
        alignment: Alignment.center,
        showShimmer: loading,
        child: loading
            ? Container(
                decoration: BoxDecoration(
                    color: context
                        .designSystem.colors.progressIndicatorBackgroundColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(context.designSystem.spacing.s))),
                width: context.designSystem.spacing.xxxl,
                height: context.designSystem.spacing.xxxl,
              )
            : Icon(
                context.designSystem.icons.message,
                size: context.designSystem.spacing.xxxxl3,
              ),
      );
}
