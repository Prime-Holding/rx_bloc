{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:widget_toolkit/ui_components.dart';
import '../../../../base/extensions/error_model_field_translations.dart';
import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/password_reset_request_bloc.dart';

class PasswordResetRequestPage extends StatelessWidget {
  const PasswordResetRequestPage({
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
                    AppErrorModalWidget<PasswordResetRequestBlocType>(
                      errorState: (bloc) => bloc.states.errors,
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
                      context.l10n.featurePasswordReset.requestPageHeader,
                      style: context.designSystem.typography.h2Reg16,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.designSystem.spacing.l),
                    RxTextFormFieldBuilder<PasswordResetRequestBlocType>(
                      state: (bloc) => bloc.states.email.translate(context),
                      showErrorState: (bloc) => bloc.states.showFieldErrors,
                      onChanged: (bloc, value) => bloc.events.setEmail(value),
                      obscureText: true,
                      builder: (fieldState) => _buildEmailField(
                        fieldState,
                        context,
                      ),
                    ),
                    SizedBox(height: context.designSystem.spacing.xl),
                    RxBlocBuilder<PasswordResetRequestBlocType, bool>(
                      state: (bloc) => bloc.states.isLoading,
                      builder: _buildRegisterButton,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  TextFormField _buildEmailField(
    RxTextFormFieldBuilderState<PasswordResetRequestBlocType> fieldState,
    BuildContext context,
  ) =>
      TextFormField(
        controller: fieldState.controller,
        textInputAction: TextInputAction.done,
        decoration: fieldState.decoration.copyWith(
          labelText: context.l10n.field.email,
          hintText: context.l10n.featureLogin.emailHint,
          hintStyle: context.designSystem.typography.h2Reg16,
        ),
      );

  GradientFillButton _buildRegisterButton(
    BuildContext context,
    AsyncSnapshot<bool> loadingState,
    PasswordResetRequestBlocType bloc,
  ) =>
      GradientFillButton(
        state: loadingState.isLoading
            ? ButtonStateModel.loading
            : ButtonStateModel.enabled,
        onPressed: bloc.events.request,
        text: context.l10n.featurePasswordReset.request,
      );
}
