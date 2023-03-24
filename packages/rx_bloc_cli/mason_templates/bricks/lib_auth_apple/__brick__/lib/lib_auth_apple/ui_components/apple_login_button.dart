{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../blocs/apple_login_bloc.dart';

/// [AppleLoginButton] provides out of the box Log in with Apple
/// functionality along with default view of the button.
///
/// In order to make it work, provide LoginWithAppleBlocType to the context
/// above this widget or use [AppleLoginButtonWithDependencies].
class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => RxBlocBuilder<AppleLoginBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, snapshot, bloc) => SignInWithAppleButton(
            onPressed: () =>
                (snapshot.data ?? false) ? null : bloc.events.loginWithApple()),
      );
}
