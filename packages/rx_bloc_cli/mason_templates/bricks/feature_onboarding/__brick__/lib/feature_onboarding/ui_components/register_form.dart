{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../base/extensions/utility_extensions.dart';
import '../blocs/onboarding_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
  void initState() {
    super.initState();

    _emailFocusNode.requestFocusSafely(context);
  }

  @override
  Widget build(BuildContext context) => Column(
        spacing: context.designSystem.spacing.m,
        children: [
          RxTextFormFieldBuilder<OnboardingBlocType>(
            state: (bloc) => bloc.states.email.translate(context),
            showErrorState: (bloc) => bloc.states.showFieldErrors,
            onChanged: (bloc, value) => bloc.events.setEmail(value),
            builder: (fieldState) => _buildEmailField(
              fieldState,
              context,
            ),
          ),
          RxTextFormFieldBuilder<OnboardingBlocType>(
            state: (bloc) => bloc.states.password.translate(context),
            showErrorState: (bloc) => bloc.states.showFieldErrors,
            onChanged: (bloc, value) => bloc.events.setPassword(value),
            obscureText: true,
            builder: (fieldState) => _buildPasswordField(
              fieldState,
              context,
            ),
          ),
          SizedBox(height: context.designSystem.spacing.xs),
          RxBlocBuilder<OnboardingBlocType, bool>(
            state: (bloc) => bloc.states.isLoading,
            builder: _buildRegisterButton,
          ),
        ],
      );

  TextFormField _buildPasswordField(
    RxTextFormFieldBuilderState<OnboardingBlocType> fieldState,
    BuildContext context,
  ) =>
      TextFormField(
        key: K.registerPassword,
        obscureText: fieldState.isTextObscured,
        controller: fieldState.controller,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocusNode,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
        decoration: fieldState.decoration.copyWith(
          labelText: context.l10n.field.password,
        ),
      );

  TextFormField _buildEmailField(
    RxTextFormFieldBuilderState<OnboardingBlocType> fieldState,
    BuildContext context,
  ) =>
      TextFormField(
        key: K.registerEmail,
        controller: fieldState.controller,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocusNode,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(_passwordFocusNode),
        decoration: fieldState.decoration.copyWith(
          labelText: context.l10n.field.email,
        ),
      );

  GradientFillButton _buildRegisterButton(
    BuildContext context,
    AsyncSnapshot<bool> loadingState,
    OnboardingBlocType bloc,
  ) =>
      GradientFillButton(
        key: K.registerButton,
        state: loadingState.isLoading
            ? ButtonStateModel.loading
            : ButtonStateModel.enabled,
        onPressed: bloc.events.register,
        text: context.l10n.featureOnboarding.register,
      );
}
