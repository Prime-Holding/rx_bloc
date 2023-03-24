{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../app_extensions.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/google_login_bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<GoogleLoginBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, loadingState, bloc) => GradientFillButton(
          state: loadingState.isLoading
              ? ButtonStateModel.loading
              : ButtonStateModel.enabled,
          text: context.l10n.googleLogin,
          onPressed: () => bloc.events.googleLogin(),
        ),
      );
}
