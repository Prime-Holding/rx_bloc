{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/onboarding_email_confirmation_bloc.dart';
import '../ui_components/show_mock_deep_link_sheet.dart';

class OnboardingEmailConfirmationPage extends StatelessWidget {
  const OnboardingEmailConfirmationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(context),
        body: SafeArea(
          child: RxBlocBuilder<OnboardingEmailConfirmationBlocType, bool>(
            state: (bloc) => bloc.states.isLoading,
            builder: (context, loading, bloc) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.designSystem.spacing.xxl,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      AppErrorModalWidget<OnboardingEmailConfirmationBlocType>(
                        errorState: (bloc) => bloc.states.errors,
                        onRetry: (_, error) => error is InvalidUrlErrorModel
                            ? bloc.events.openMockDeepLinkSuccess()
                            : bloc.events.sendNewLink(),
                      ),
                      ShimmerWrapper(
                        alignment: Alignment.center,
                        showShimmer: loading.isLoading,
                        baseColor: context.designSystem.colors.white,
                        highlightColor: context.designSystem.colors.white
                            .withValues(alpha: 50),
                        child: loading.isLoading
                            ? Container(
                                decoration: BoxDecoration(
                                    color: context.designSystem.colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            context.designSystem.spacing.s))),
                                width: context.designSystem.spacing.xxxl,
                                height: context.designSystem.spacing.xxxl,
                              )
                            : Icon(
                                context.designSystem.icons.message,
                                size: context.designSystem.spacing.xxxxl3,
                              ),
                      ),
                      SizedBox(height: context.designSystem.spacing.l),
                      Text(
                        context.l10n.featureOnboarding.titleEmailConfirmation,
                        style: context.designSystem.typography.h1Med32,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.designSystem.spacing.xs),
                      RxBlocBuilder<OnboardingEmailConfirmationBlocType,
                          String>(
                        state: (bloc) => bloc.states.email,
                        builder: (context, email, bloc) => ShimmerText(
                          loading.isLoading
                              ? null
                              : context.l10n.featureOnboarding
                                  .emailConfirmationSent(email.data ?? ''),
                          textAlign: TextAlign.center,
                          alignment: Alignment.center,
                          baseColor: context.designSystem.colors.white,
                          highlightColor: context.designSystem.colors.white
                              .withValues(alpha: 50),
                          type: ShimmerType.fixed(placeholderLength: 2),
                          style: context.designSystem.typography.h2Reg16,
                        ),
                      ),
                      SizedBox(
                        height: context.designSystem.spacing.xxl,
                      ),
                      //TODO: Used for demo purposes, should be removed in areal app
                      Material(
                        child: InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              context.designSystem.spacing.m,
                            ),
                          ),
                          onTap: loading.isLoading
                              ? null
                              : () => showMockDeepLinkSheet(
                                    context,
                                    onDeepLinkSuccessTapped: () =>
                                        bloc.events.openMockDeepLinkSuccess(),
                                    onDeepLinkErrorTapped: () =>
                                        bloc.events.openMockDeepLinkError(),
                                  ),
                          child: MessagePanelWidget(
                            isLoading: loading.isLoading,
                            message:
                                context.l10n.featureOnboarding.pleaseOpenEmail,
                            messageState: MessagePanelState.positive,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GradientFillButton(
                        onPressed: loading.isLoading
                            ? null
                            : () => context
                                .read<OnboardingEmailConfirmationBlocType>()
                                .events
                                .openMailClient(context
                                    .l10n.featureOnboarding.selectMailApp),
                        text: context.l10n.featureOnboarding.openMailClient,
                      ),
                      SizedBox(
                        height: context.designSystem.spacing.s,
                      ),
                      _sendNewLinkButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _sendNewLinkButton() =>
      RxBlocMultiBuilder2<OnboardingEmailConfirmationBlocType, bool, bool>(
        state1: (bloc) => bloc.states.isSendNewLinkActive,
        state2: (bloc) => bloc.states.isLoading,
        builder: (context, isSendNewLinkActivated, loading, bloc) =>
            IconTextButton(
          text: context.l10n.featureOnboarding.sendNewLink.toUpperCase(),
          state: loading.isLoading
              ? ButtonStateModel.loading
              : isSendNewLinkActivated.isLoading
                  ? ButtonStateModel.disabled
                  : ButtonStateModel.enabled,
          icon: Container(),
          onPressed: isSendNewLinkActivated.isLoading || loading.isLoading
              ? null
              : () => bloc.events.sendNewLink(),
        ),
      );
}
