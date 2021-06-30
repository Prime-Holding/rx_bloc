// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../blocs/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    this.title = 'Enter your login credentials',
    this.onLoginSuccess,
  });

  final String title;
  final Function? onLoginSuccess;

  @override
  _LoginFormState createState() => _LoginFormState();
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
    _focusNodes.forEach((focusNode) => focusNode.dispose());
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
              style: context.designSystem.typography.bodyText2,
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                _buildFieldEmail(),
                const SizedBox(height: 10),
                _buildFieldPassword(),
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
                _buildErrorListener(),
                _buildLogoutListener(),
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
          child: Text(context.l10n.logIn),
        ),
      );

  Widget _buildLogoutListener() => RxBlocListener<LoginBlocType, bool>(
        state: (bloc) => bloc.states.loggedIn,
        listener: (_, success) {
          if (success ?? false) widget.onLoginSuccess?.call();
        },
      );

  Widget _buildErrorListener() => RxBlocListener<LoginBlocType, String>(
        state: (bloc) => bloc.states.errors,
        listener: (context, error) {
          if (error?.isEmpty ?? true) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error!),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );

  Widget _buildFieldEmail() => RxTextFormFieldBuilder<LoginBlocType>(
        state: (bloc) => bloc.states.username,
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

  Widget _buildFieldPassword() => RxTextFormFieldBuilder<LoginBlocType>(
        state: (bloc) => bloc.states.password,
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
      decoration.copyWith(
        labelText: label,
        labelStyle: decoration.labelStyle?.copyWith(
          color: context.designSystem.colors.inputDecorationLabelColor
              .withOpacity(0.5),
        ),
        errorStyle: decoration.labelStyle?.copyWith(
          color: context.designSystem.colors.inputDecorationErrorLabelColor,
        ),
      );
}
