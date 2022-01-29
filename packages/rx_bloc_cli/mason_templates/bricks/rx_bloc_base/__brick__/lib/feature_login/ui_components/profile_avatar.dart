{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_blocs/user_account_bloc.dart';
import '../../base/common_ui_components/popup_builder.dart';

// ignore_for_file: avoid_field_initializers_in_const_classes

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    Key? key,
  }) : super(key: key);

  final _notificationKey = 'notifications';
  final _logoutKey = 'logout';

  /// region Builders

  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<UserAccountBlocType, bool>(
        state: (bloc) => bloc.states.loggedIn,
        builder: (context, loggedInState, bloc) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: (loggedInState.hasData && loggedInState.data!)
              ? _buildLoggedInAvatar(context)
              : _buildLoginButton(context),
        ),
      );

  Widget _buildLoginButton(BuildContext context) => IconButton(
        icon: Icon(context.designSystem.icons.login),
        tooltip: context.l10n.logIn,
        onPressed: () => context.router.push(const LoginRoute()),
      );

  Widget _buildLoggedInAvatar(BuildContext context) => PopupBuilder<String>(
        tooltip: context.l10n.profile,
        items: [
          PopupMenuItem<String>(
            value: _notificationKey,
            child: Text(
              context.l10n.notifications,
              style: context.designSystem.typography.fadedButtonText,
            ),
          ),
          const PopupMenuDivider(height: 2),
          PopupMenuItem<String>(
            value: _logoutKey,
            child: Text(
              context.l10n.logOut,
              style: context.designSystem.typography.fadedButtonText,
            ),
          ),
        ],
        onSelected: (selected) {
          if (selected == _notificationKey) {
            context.router.push(const NotificationsRoute());
          } else if (selected == _logoutKey) {
            context.read<UserAccountBlocType>().events.logout();
          }
        },
        child: Icon(context.designSystem.icons.avatar),
      );

  /// endregion

}
