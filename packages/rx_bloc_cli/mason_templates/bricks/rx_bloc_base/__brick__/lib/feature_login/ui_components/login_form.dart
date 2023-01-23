{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../base/extensions/error_model_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    this.title = 'Enter your login credentials',
    this.onLoginSuccess,
    Key? key,
  }) : super(key: key);

  final String title;
  final Function? onLoginSuccess;

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
        padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 10),
                _buildFieldPassword(context),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(indent: 5, endIndent: 5),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildLogInButton(),
                ),
                RxBlocListener<LoginBlocType, ErrorModel>(
                  state: (bloc) => bloc.states.errors,
                  listener: _onError,
                ),
                RxBlocListener<LoginBlocType, bool>(
                  state: (bloc) => bloc.states.loggedIn,
                  listener: _onLogout,
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildLogInButton() => RxBlocBuilder<LoginBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, loadingState, bloc) => PrimaryButton(
          isLoading: loadingState.hasData ? loadingState.data! : false,
          onPressed: bloc.events.login,
          child: Text(context.l10n.featureLogin.logIn),
        ),
      );

  Widget _buildFieldEmail(BuildContext context) =>
      RxTextFormFieldBuilder<LoginBlocType>(
        state: (bloc) => bloc.states.username.translate(context),
        showErrorState: (bloc) => bloc.states.showErrors,
        onChanged: (bloc, value) => bloc.events.setUsername(value),
        builder: (fieldState) => TextFormField(
          controller: fieldState.controller,
          textInputAction: TextInputAction.next,
          focusNode: _emailFocusNode,
          onEditingComplete: () =>
              FocusScope.of(context).requestFocus(_passwordFocusNode),
          decoration: _getFieldDecoration(fieldState.decoration, 'Email'),
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
          decoration: _getFieldDecoration(fieldState.decoration, 'Password'),
        ),
      );

  InputDecoration _getFieldDecoration(
    InputDecoration decoration,
    String label,
  ) =>
      decoration.copyWith(labelText: label);

  void _onError(BuildContext context, ErrorModel error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.translate(context)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onLogout(BuildContext _, bool success) {
    if (success) widget.onLoginSuccess?.call();
  }
}
