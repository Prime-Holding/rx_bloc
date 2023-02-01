{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_blocs/user_account_bloc.dart';
import '../../base/common_ui_components/popup_builder.dart';
import '../../base/routers/router.dart';
import '../../feature_counter/blocs/counter_bloc.dart';
import '../../feature_enter_message/di/enter_message_with_dependencies.dart';
import '../../lib_navigation/blocs/navigation_bloc.dart';

// ignore_for_file: avoid_field_initializers_in_const_classes

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    Key? key,
  }) : super(key: key);

  final _notificationKey = 'notifications';
  final _logoutKey = 'logout';
  final _pageWithResultKey = 'pageWithResult';
  final _deepLinkFlow = 'deepLinkFlow';

  /// region Builders

  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<UserAccountBlocType, bool>(
        state: (bloc) => bloc.states.loggedIn,
        builder: (context, loggedInState, bloc) => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.designSystem.spacing.s,
            ),
          child: (loggedInState.hasData && loggedInState.data!)
              ? _buildLoggedInAvatar(context)
              : _buildLoginButton(context),
        ),
      );

  Widget _buildLoginButton(BuildContext context) => IconButton(
    icon: Icon(context.designSystem.icons.login),
    tooltip: context.l10n.featureLogin.logIn,
    onPressed: () =>
        context.read<NavigationBlocType>().events.goTo(const LoginRoute()),
  );

  Widget _buildLoggedInAvatar(BuildContext context) => PopupBuilder<String>(
    tooltip: context.l10n.featureLogin.profile,
    items: [
      PopupMenuItem<String>(
        value: _notificationKey,
        child: Text(
          context.l10n.featureLogin.notifications,
          style: context.designSystem.typography.fadedButtonText,
        ),
      ),
      PopupMenuDivider(height: context.designSystem.spacing.xxxs),
      PopupMenuItem<String>(
        value: _deepLinkFlow,
        child: Text(
          context.l10n.deepLinkFlowMenu,
          style: context.designSystem.typography.fadedButtonText,
        ),
      ),
      PopupMenuDivider(height: context.designSystem.spacing.xxxs),
      PopupMenuItem<String>(
        value: _pageWithResultKey,
        child: Text(
          context.l10n.pageWithResult,
          style: context.designSystem.typography.fadedButtonText,
        ),
      ),
      PopupMenuDivider(height: context.designSystem.spacing.xxxs),
      PopupMenuItem<String>(
        value: _logoutKey,
        child: Text(
          context.l10n.featureLogin.logOut,
          style: context.designSystem.typography.fadedButtonText,
        ),
      ),
    ],
    onSelected: (selected) async {
      if (selected == _notificationKey) {
        context
            .read<NavigationBlocType>()
            .events
            .goTo(const NotificationsRoute());
      } else if (selected == _logoutKey) {
        context.read<UserAccountBlocType>().events.logout();
      } else if (selected == _pageWithResultKey) {
        final response = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const EnterMessageWithDependencies(),
          ),
        );

        if (response == null) {
          return;
        }

        if (context.mounted) {
          context.read<CounterBlocType>().events.setMessage(response);
        }
      } else if (selected == _deepLinkFlow) {
        context.read<NavigationBlocType>().events.goTo(const ItemsRoute());
      }
    },
    child: Icon(
      context.designSystem.icons.avatar,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );

/// endregion
}
