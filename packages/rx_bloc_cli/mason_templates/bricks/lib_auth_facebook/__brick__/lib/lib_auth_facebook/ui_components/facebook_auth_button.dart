import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/facebook_auth_bloc.dart';

class FacebookAuthButton extends StatelessWidget {
  const FacebookAuthButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<FacebookAuthBlocType, bool>(
          bloc: context.read<FacebookAuthBlocType>(),
          state: (bloc) => bloc.states.isLoading,
          builder: (context, loadingState, bloc) => GradientFillButton(
                state: loadingState.isLoading
                    ? ButtonStateModel.loading
                    : ButtonStateModel.enabled,
                text: context.l10n.loginWithFb,
                onPressed: () => bloc.events.loginWithFb(),
              ));
}
