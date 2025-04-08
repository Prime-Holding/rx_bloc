{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/language_picker.dart';
import 'package:widget_toolkit/shimmer.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../../../base/models/errors/error_model.dart';
import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/common_ui_components/show_mock_deep_link_sheet.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/password_reset_confirmation_bloc.dart';
import '../services/password_reset_confirmation_service.dart';

class PasswordResetConfirmationPage extends StatelessWidget {
  const PasswordResetConfirmationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(context),
        body: SafeArea(
          child: RxBlocBuilder<PasswordResetConfirmationBlocType, bool>(
            state: (bloc) => bloc.states.isLoading,
            builder: (context, loading, bloc) => Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.designSystem.spacing.xxl,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          AppErrorModalWidget<
                              PasswordResetConfirmationBlocType>(
                            errorState: (bloc) => bloc.states.errors,
                            onRetry: (_, error) => error is InvalidUrlErrorModel
                                ? bloc.events.openMockDeepLinkSuccess()
                                : bloc.events.sendNewLink(),
                          ),
                          ShimmerWrapper(
                            alignment: Alignment.center,
                            showShimmer: loading.isLoading,
                            baseColor: context.designSystem.colors
                                .progressIndicatorBackgroundColor,
                            highlightColor: context.designSystem.colors
                                .progressIndicatorBackgroundColor
                                .withValues(alpha: 0.2),
                            child: loading.isLoading
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: context.designSystem.colors
                                            .progressIndicatorBackgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(context
                                                .designSystem.spacing.s))),
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
                            context.l10n.featurePasswordReset
                                .titleEmailConfirmation,
                            style: context.designSystem.typography.h1Med32,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: context.designSystem.spacing.xs),
                          RxBlocBuilder<PasswordResetConfirmationBlocType,
                              String>(
                            state: (bloc) => bloc.states.email,
                            builder: (context, email, bloc) => Column(
                              children: [
                                ShimmerText(
                                  loading.isLoading
                                      ? null
                                      : context.l10n.featurePasswordReset
                                          .emailConfirmationSent(
                                              email.data ?? ''),
                                  textAlign: TextAlign.center,
                                  alignment: Alignment.center,
                                  baseColor: context.designSystem.colors
                                      .progressIndicatorBackgroundColor,
                                  highlightColor: context.designSystem.colors
                                      .progressIndicatorBackgroundColor
                                      .withValues(alpha: 0.2),
                                  type: ShimmerType.fixed(placeholderLength: 2),
                                  style:
                                      context.designSystem.typography.h2Reg16,
                                ),
                                SizedBox(
                                  height: context.designSystem.spacing.xxl,
                                ),
                                //TODO: Used for demo purposes, should be removed in a real app
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
                                              deepLinkSuccess:
                                                  mockEmailDeepLinkSuccess(
                                                      email.data ?? ''),
                                              deepLinkError:
                                                  mockEmailDeepLinkError(
                                                      email.data ?? ''),
                                              onDeepLinkSuccessTapped: () => bloc
                                                  .events
                                                  .openMockDeepLinkSuccess(),
                                              onDeepLinkErrorTapped: () => bloc
                                                  .events
                                                  .openMockDeepLinkError(),
                                            ),
                                    child: MessagePanelWidget(
                                      isLoading: loading.isLoading,
                                      message: context.l10n.featurePasswordReset
                                          .pleaseOpenEmail,
                                      messageState: MessagePanelState.positive,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: context.designSystem.spacing.xxl,
                      ),
                      Column(
                        children: [
                          GradientFillButton(
                            onPressed: loading.isLoading
                                ? null
                                : () => context
                                    .read<PasswordResetConfirmationBlocType>()
                                    .events
                                    .openMailClient(context.l10n
                                        .featurePasswordReset.selectMailApp),
                            text: context
                                .l10n.featurePasswordReset.openMailClient,
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
          ),
        ),
      );

  Widget _sendNewLinkButton() =>
      RxBlocMultiBuilder2<PasswordResetConfirmationBlocType, bool, bool>(
        state1: (bloc) => bloc.states.isSendNewLinkActive,
        state2: (bloc) => bloc.states.isLoading,
        builder: (context, isSendNewLinkActivated, loading, bloc) =>
            IconTextButton(
          text: context.l10n.featurePasswordReset.sendNewLink.toUpperCase(),
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
