import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/google_login_bloc.dart';

class LibAuthGoogleButton extends StatelessWidget {
  const LibAuthGoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          AppErrorModalWidget<GoogleLoginBlocType>(
            errorState: (bloc) => bloc.states.errors,
          ),
          _googleLoginButton(),
        ],
      );
}

Widget _googleLoginButton() => RxBlocBuilder<GoogleLoginBlocType, bool>(
      state: (bloc) => bloc.states.isLoading,
      builder: (context, loadingState, bloc) => GradientFillButton(
        state: loadingState.isLoading
            ? ButtonStateModel.loading
            : ButtonStateModel.enabled,
        text: context.l10n.googleLogin,
        onPressed: () => bloc.events.googleLogin(),
      ),
    );
