{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../../lib_auth/blocs/user_account_bloc.dart';

class LogoutActionButton extends StatelessWidget {
  const LogoutActionButton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            EdgeInsets.symmetric(horizontal: context.designSystem.spacing.m),
        child: RxBlocMultiBuilder2<UserAccountBlocType, bool, bool>(
          state1: (bloc) => bloc.states.isLoading,
          state2: (bloc) => bloc.states.loggedIn,
          builder: (context, loading, loggedIn, bloc) => Visibility(
            visible: loggedIn.data ?? false,
            child: IconButton(
              highlightColor: context.designSystem.colors.transparent,
              icon: loading.isLoading
                  ? AppLoadingIndicator.textButtonValue(
                      context,
                      color: context.designSystem.colors.textButtonColor,
                    )
                  : context.designSystem.icons.logoutIcon,
              onPressed: loading.isLoading
                  ? null
                  : context.read<UserAccountBlocType>().events.logout,
            ),
          ),
        ),
      );
}
