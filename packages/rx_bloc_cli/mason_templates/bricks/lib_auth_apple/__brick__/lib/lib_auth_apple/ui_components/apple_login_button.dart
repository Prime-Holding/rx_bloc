{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/apple_login_bloc.dart';

/// [AppleLoginButton] provides out of the box Log in with Apple
/// functionality along with default view of the button. If you want to customize
/// the way button looks use [builder].
///
/// If an error occur a modal sheet with message will be shown. For custom error
/// handling provide [onError] callback.
///
/// In order to make it work, provide LoginWithAppleBlocType to the context
/// above this widget or use [AppleLoginButtonWithDependencies].
class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({
    this.builder,
    this.onError,
    Key? key,
  }) : super(key: key);

  final Widget Function(bool isLoading, void Function() onPressed)? builder;
  final void Function(BuildContext context, ErrorModel error)? onError;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (onError == null)
        AppErrorModalWidget<AppleLoginBlocType>(
          errorState: (bloc) => bloc.states.errors,
        ),
      if (onError != null)
        RxBlocListener<AppleLoginBlocType, ErrorModel>(
            listener: (context, error) => onError!.call(context, error),
            state: (bloc) => bloc.states.errors),
      RxBlocBuilder<AppleLoginBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, snapshot, bloc) =>
        builder?.call(
            snapshot.data ?? false, bloc.events.loginWithApple) ??
            SignInWithAppleButton(
                onPressed: () => (snapshot.data ?? false)
                    ? null
                    : bloc.events.loginWithApple()),
      ),
    ],
  );
}
