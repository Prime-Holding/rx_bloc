{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/app_open_mail_widget.dart';
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
        appBar: customAppBar(context,
            title: context.l10n.featureOnboarding.titleEmailConfirmation),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              0,
              0,
              context.designSystem.spacing.m,
            ),
            child: RxBlocBuilder<OnboardingEmailConfirmationBlocType, bool>(
              state: (bloc) => bloc.states.isLoading,
              builder: (context, loading, bloc) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.designSystem.spacing.m,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          AppOpenMailWidget<
                              OnboardingEmailConfirmationBlocType>(
                            openMailState: (bloc) => bloc.states.openMailApp,
                          ),
                          AppErrorModalWidget<
                              OnboardingEmailConfirmationBlocType>(
                            errorState: (bloc) => bloc.states.errors,
                            onRetry: (_, error) => error is InvalidUrlErrorModel
                                ? bloc.events.openMockDeepLinkSuccess()
                                : bloc.events.sendNewLink(),
                          ),
                          SizedBox(
                            height: context.designSystem.spacing.xxxxl1,
                          ),
                          ShimmerWrapper(
                            alignment: Alignment.center,
                            showShimmer: loading.isLoading,
                            baseColor: context.designSystem.colors.white,
                            highlightColor: context.designSystem.colors.white
                                .withOpacity(0.2),
                            child: loading.isLoading
                                ? Container(
                                    decoration: BoxDecoration(
                                        color:
                                            context.designSystem.colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(context
                                                .designSystem.spacing.s))),
                                    width: context.designSystem.spacing.xxxxl2,
                                    height: context.designSystem.spacing.xxxxl2,
                                  )
                                : Icon(
                                    context.designSystem.icons.message,
                                    size: context.designSystem.spacing.xxxxl2,
                                  ),
                          ),
                          SizedBox(
                            height: context.designSystem.spacing.xl,
                          ),
                          ShimmerText(
                            loading.isLoading
                                ? null
                                : context.l10n.featureOnboarding
                                    .emailConfirmationSent,
                            textAlign: TextAlign.center,
                            alignment: Alignment.center,
                            baseColor: context.designSystem.colors.white,
                            highlightColor: context.designSystem.colors.white
                                .withOpacity(0.2),
                            type: ShimmerType.fixed(placeholderLength: 2),
                          ),
                          if (loading.isLoading)
                            SizedBox(
                              height: context.designSystem.spacing.xs,
                            ),
                          RxBlocBuilder<OnboardingEmailConfirmationBlocType,
                              String>(
                            state: (bloc) => bloc.states.email,
                            builder: (context, email, bloc) => ShimmerText(
                              loading.isLoading ? null : email.data ?? '',
                              textAlign: TextAlign.center,
                              alignment: Alignment.center,
                              baseColor: context.designSystem.colors.white,
                              highlightColor: context.designSystem.colors.white
                                  .withOpacity(0.2),
                            ),
                          ),
                          SizedBox(
                            height: context.designSystem.spacing.xl,
                          ),
                          Material(
                            child: InkWell(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  context.designSystem.spacing.m,
                                ),
                              ),
                              // Used for demo purposes, should be removed in a
                              // real app
                              onTap: loading.isLoading
                                  ? null
                                  : () => showMockDeepLinkSheet(
                                        context,
                                        onDeepLinkSuccessTapped: () => bloc
                                            .events
                                            .openMockDeepLinkSuccess(),
                                        onDeepLinkErrorTapped: () =>
                                            bloc.events.openMockDeepLinkError(),
                                      ),
                              child: MessagePanelWidget(
                                isLoading: loading.isLoading,
                                message: context
                                    .l10n.featureOnboarding.pleaseOpenEmail,
                                messageState: MessagePanelState.positive,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          height: context.designSystem.spacing.xl,
                        ),
                        _sendNewLinkButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ),
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
