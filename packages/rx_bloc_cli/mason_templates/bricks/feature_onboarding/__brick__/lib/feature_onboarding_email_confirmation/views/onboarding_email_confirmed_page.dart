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
            appBar: customAppBar(
              context,
              title: context.l10n.featureOnboarding.titleEmailConfirmation,
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    context.designSystem.spacing.m,
                    0,
                    context.designSystem.spacing.m,
                    context.designSystem.spacing.m),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppErrorModalWidget<OnboardingEmailConfirmedBlocType>(
                      errorState: (bloc) => bloc.states.errors,
                      onRetry: (_, __) => bloc.events.fetchData(),
                      onCancel: () => bloc.events.goToLogin(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShimmerWrapper(
                              alignment: Alignment.center,
                              showShimmer: loading.isLoading,
                              child: loading.isLoading
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color:
                                              context.designSystem.colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(context
                                                  .designSystem.spacing.s))),
                                      width:
                                          context.designSystem.spacing.xxxxl2,
                                      height:
                                          context.designSystem.spacing.xxxxl2,
                                    )
                                  : Icon(
                                      context.designSystem.icons.message,
                                      size: context.designSystem.spacing.xxxxl2,
                                      color: context
                                          .designSystem.colors.darkSeaGreen,
                                    ),
                            ),
                            SizedBox(
                              height: context.designSystem.spacing.xl,
                            ),
                            ShimmerText(
                              loading.isLoading
                                  ? null
                                  : context.l10n.featureOnboarding
                                      .titleEmailConfirmed,
                              textAlign: TextAlign.center,
                              alignment: Alignment.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(context.designSystem.spacing.m),
                      child: _startButton(
                        context,
                        isLoading: loading.isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _startButton(
    BuildContext context, {
    bool isLoading = false,
    bool isDisabled = false,
  }) =>
      GradientFillButton(
        areIconsClose: true,
        text: context.l10n.continueText,
        state: isLoading ? ButtonStateModel.loading : ButtonStateModel.enabled,
        onPressed: isDisabled
            ? null
            : () => context
                .read<OnboardingEmailConfirmedBlocType>()
                .events
                .goToPhonePage(),
      );
}
