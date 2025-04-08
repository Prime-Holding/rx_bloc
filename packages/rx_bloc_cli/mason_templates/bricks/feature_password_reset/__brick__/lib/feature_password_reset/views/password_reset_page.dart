{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';
import '../../../../base/extensions/error_model_field_translations.dart';
import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/password_reset_bloc.dart';
import 'password_reset_confirmed_page.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<PasswordResetBlocType, bool>(
        state: (bloc) => bloc.states.isResetSuccessful,
        builder: (context, isReset, bloc) => isReset.isLoading
            ? PasswordResetConfirmedPage()
            : RxUnfocuser(
                child: Scaffold(
                  appBar: customAppBar(
                    context,
                  ),
                  body: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.designSystem.spacing.xxl,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            RxBlocListener<PasswordResetBlocType, bool>(
                              state: (bloc) => bloc.states.isTokenResent,
                              listener: (_, __) =>
                                  _showTokenResentSheet(context),
                            ),
                            AppErrorModalWidget<PasswordResetBlocType>(
                              errorState: (bloc) => bloc.states.errors,
                              onRetry: (_, error) =>
                                  context
                                      .read<PasswordResetBlocType>()
                                      .events
                                      .sendNewLink(),
                              retryButtonText:
                                  context.l10n.featurePasswordReset.sendNewLink,
                            ),
                            SizedBox(height: context.designSystem.spacing.xxl),
                            Icon(
                              context.designSystem.icons.key,
                              size: context.designSystem.spacing.xxxxl3,
                            ),
                            SizedBox(height: context.designSystem.spacing.s),
                            Text(
                              context.l10n.featurePasswordReset.passwordReset,
                              style: context.designSystem.typography.h1Med32,
                            ),
                            SizedBox(height: context.designSystem.spacing.xs),
                            Text(
                              context.l10n.featurePasswordReset.resetPageHeader,
                              style: context.designSystem.typography.h2Reg16,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: context.designSystem.spacing.l),
                            RxBlocBuilder<PasswordResetBlocType, bool>(
                              state: (bloc) => bloc.states.isLoading,
                              builder: (context, isLoading, bloc) => Column(
                                children: [
                                  RxTextFormFieldBuilder<PasswordResetBlocType>(
                                    state: (bloc) =>
                                        bloc.states.password.translate(context),
                                    showErrorState: (bloc) =>
                                        bloc.states.showFieldErrors,
                                    onChanged: (bloc, value) =>
                                        bloc.events.setPassword(value),
                                    obscureText: true,
                                    builder: (fieldState) =>
                                        _buildPasswordField(
                                      fieldState,
                                      context,
                                      isLoading.isLoading,
                                    ),
                                  ),
                                  SizedBox(
                                      height: context.designSystem.spacing.xl),
                                  _buildRegisterButton(
                                      context, isLoading, bloc),
                                ],
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

  void _showTokenResentSheet(
    BuildContext context,
  ) =>
      showBlurredBottomSheet(
        context: context,
        builder: (BuildContext context) => MessagePanelWidget(
          message: context.l10n.featurePasswordReset.tokenResent,
          messageState: MessagePanelState.informative,
        ),
      );

  Widget _buildPasswordField(
    RxTextFormFieldBuilderState<PasswordResetBlocType> fieldState,
    BuildContext context,
    bool isLoading,
  ) =>
      TextFormField(
        obscureText: fieldState.isTextObscured,
        controller: fieldState.controller,
        textInputAction: TextInputAction.done,
        decoration: fieldState.decoration.copyWith(
          labelStyle: fieldState.showError
              ? fieldState.decoration.labelStyle
              : fieldState.decoration.labelStyle
                  ?.copyWith(color: DefaultTextStyle.of(context).style.color),
          labelText: context.l10n.field.password,
          hintText: context.l10n.featureLogin.passwordHint,
          hintStyle: context.designSystem.typography.h2Reg16,
        ),
      );

  GradientFillButton _buildRegisterButton(
    BuildContext context,
    AsyncSnapshot<bool> loadingState,
    PasswordResetBlocType bloc,
  ) =>
      GradientFillButton(
        state: loadingState.isLoading
            ? ButtonStateModel.loading
            : ButtonStateModel.enabled,
        onPressed: bloc.events.resetPassword,
        text: context.l10n.featurePasswordReset.reset,
      );
}
