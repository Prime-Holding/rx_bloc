{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../../base/extensions/error_model_field_translations.dart';{{#enable_forgotten_password}}
import '../../lib_router/router.dart';{{/enable_forgotten_password}}
import '../blocs/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    this.title = 'Enter your login credentials',
    super.key,
  });

  final String title;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailFocusNode = FocusNode(debugLabel: 'emailFocus');
  final _passwordFocusNode = FocusNode(debugLabel: 'passwordFocus');

  /// Get all focus nodes of the form
  List<FocusNode> get _focusNodes => [
        _emailFocusNode,
        _passwordFocusNode,
      ];

  @override
  void dispose() {
// Since the focus nodes are long living object, they should be disposed.
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RxTextFormFieldBuilder<LoginBlocType>(
            state: (bloc) => bloc.states.email.translate(context),
            showErrorState: (bloc) => bloc.states.showErrors,
            onChanged: (bloc, value) => bloc.events.setEmail(value),
            builder: (fieldState) => _buildEmailField(
              fieldState,
              context,
            ),
          ),
          RxTextFormFieldBuilder<LoginBlocType>(
            state: (bloc) => bloc.states.password.translate(context),
            showErrorState: (bloc) => bloc.states.showErrors,
            onChanged: (bloc, value) => bloc.events.setPassword(value),
            obscureText: true,
            builder: (fieldState) => _buildPasswordField(
              fieldState,
              context,
            ),
          ),
          SizedBox(height: context.designSystem.spacing.m),
          RxBlocBuilder<LoginBlocType, bool>(
            state: (bloc) => bloc.states.isLoading,
            builder: _buildLoginButton,
          ),
          SizedBox(height: context.designSystem.spacing.xss1),{{#enable_forgotten_password}}
          TextButton(
            onPressed: () =>
              GoRouter.of(context).go(PasswordResetRequestRoute().routeLocation),
            child: Text(context.l10n.featureLogin.forgottenPassword),
          ),
          SizedBox(height: context.designSystem.spacing.xs1),{{/enable_forgotten_password}}
          AppErrorModalWidget<LoginBlocType>(
            errorState: (bloc) => bloc.states.errors,
          ),
        ],
      );

  TextFormField _buildPasswordField(
    RxTextFormFieldBuilderState<LoginBlocType> fieldState,
    BuildContext context,
  ) =>
      TextFormField(
        key: K.loginPassword,
        obscureText: fieldState.isTextObscured,
        controller: fieldState.controller,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocusNode,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
        decoration: fieldState.decoration.copyWith(
          labelStyle: fieldState.showError
              ? fieldState.decoration.labelStyle
              : fieldState.decoration.labelStyle
                  ?.copyWith(color: DefaultTextStyle.of(context).style.color),
          labelText: context.l10n.field.password,
          hintText: context.l10n.featureLogin.passwordHint,
          hintStyle: context.designSystem.typography.h2Reg16,
          helperText: ' ', // this will prevent the error text from shifting
        ),
      );

  TextFormField _buildEmailField(
    RxTextFormFieldBuilderState<LoginBlocType> fieldState,
    BuildContext context,
  ) =>
      TextFormField(
        key: K.loginEmail,
        controller: fieldState.controller,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocusNode,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(_passwordFocusNode),
        decoration: fieldState.decoration.copyWith(
          labelStyle: fieldState.showError
              ? fieldState.decoration.labelStyle
              : fieldState.decoration.labelStyle
                  ?.copyWith(color: DefaultTextStyle.of(context).style.color),
          labelText: context.l10n.field.email,
          hintText: context.l10n.featureLogin.emailHint,
          hintStyle: context.designSystem.typography.h2Reg16,
          helperText: ' ', // this will prevent the error text from shifting
        ),
      );

  GradientFillButton _buildLoginButton(
    BuildContext context,
    AsyncSnapshot<bool> loadingState,
    LoginBlocType bloc,
  ) =>
      GradientFillButton(
        key: K.loginButton,
        state: loadingState.isLoading
            ? ButtonStateModel.loading
            : ButtonStateModel.enabled,
        onPressed: bloc.events.login,
        text: context.l10n.featureLogin.logIn,
      );
}
