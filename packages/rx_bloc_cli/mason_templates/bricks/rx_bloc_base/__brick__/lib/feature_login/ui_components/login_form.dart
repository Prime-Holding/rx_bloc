{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../../base/extensions/error_model_field_translations.dart';

import '../blocs/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    this.title = 'Enter your login credentials',
    Key? key,
  }) : super(key: key);

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
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(
          context.designSystem.spacing.m,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: context.designSystem.typography.h3Reg14,
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                _buildFieldEmail(context),
                SizedBox(height: context.designSystem.spacing.xs1),
                _buildFieldPassword(context),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(indent: 5, endIndent: 5),
                SizedBox(height: context.designSystem.spacing.xs1),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.designSystem.spacing.l,
                  ),
                  child: _buildLogInButton(),
                ),
                AppErrorModalWidget<LoginBlocType>(
                  errorState: (bloc) => bloc.states.errors,
                ),
              ],
            ),
          ],
        ),
      );
  Widget _buildLogInButton() => RxBlocBuilder<LoginBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, loadingState, bloc) => GradientFillButton(
          state: loadingState.isLoading
              ? ButtonStateModel.loading
              : ButtonStateModel.enabled,
          onPressed: bloc.events.login,
          text: context.l10n.featureLogin.logIn,
        ),
      );

  Widget _buildFieldEmail(BuildContext context) =>
      RxTextFormFieldBuilder<LoginBlocType>(
        state: (bloc) => bloc.states.email.translate(context),
        showErrorState: (bloc) => bloc.states.showErrors,
        onChanged: (bloc, value) => bloc.events.setEmail(value),
        builder: (fieldState) => TextFormField(
          controller: fieldState.controller,
          textInputAction: TextInputAction.next,
          focusNode: _emailFocusNode,
          onEditingComplete: () =>
              FocusScope.of(context).requestFocus(_passwordFocusNode),
          decoration: _getFieldDecoration(
            fieldState.decoration,
            context.l10n.field.email,
          ),
        ),
      );

  Widget _buildFieldPassword(BuildContext context) =>
      RxTextFormFieldBuilder<LoginBlocType>(
        state: (bloc) => bloc.states.password.translate(context),
        showErrorState: (bloc) => bloc.states.showErrors,
        onChanged: (bloc, value) => bloc.events.setPassword(value),
        obscureText: true,
        builder: (fieldState) => TextFormField(
          obscureText: fieldState.isTextObscured,
          controller: fieldState.controller,
          textInputAction: TextInputAction.done,
          focusNode: _passwordFocusNode,
          onEditingComplete: () => FocusScope.of(context).unfocus(),
          decoration: _getFieldDecoration(
            fieldState.decoration,
            context.l10n.field.password,
          ),
        ),
      );

  InputDecoration _getFieldDecoration(
    InputDecoration decoration,
    String label,
  ) =>
      decoration.copyWith(labelText: label);
}
