// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/popup_builder.dart';

// ignore_for_file: avoid_field_initializers_in_const_classes

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    this.loggedIn = true,
    Key? key,
  }) : super(key: key);

  final bool loggedIn;

  final _notificationKey = 'notifications';
  final _logoutKey = 'logout';

  /// region Builders

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12),
        child: loggedIn
            ? _buildLoggedInAvatar(context)
            : _buildLoginButton(context),
      );

  Widget _buildLoginButton(BuildContext context) => OutlinedButton(
        onPressed: () => context.router.push(const LoginRoute()),
        child: Text(
          context.l10n.logIn,
          style: context.designSystem.typography.buttonFaded,
        ),
      );

  Widget _buildLoggedInAvatar(BuildContext context) => PopupBuilder<String>(
        items: [
          PopupMenuItem<String>(
            value: _notificationKey,
            child: Text(
              context.l10n.notifications,
              style: context.designSystem.typography.buttonFaded,
            ),
          ),
          const PopupMenuDivider(height: 2),
          PopupMenuItem<String>(
            value: _logoutKey,
            child: Text(
              context.l10n.logOut,
              style: context.designSystem.typography.buttonFaded,
            ),
          ),
        ],
        onSelected: (selected) {
          if (selected == _notificationKey) {
            context.router.push(const NotificationsRoute());
          } else if (selected == _logoutKey) {
            // Perform a logout
            debugPrint('User logged out');
          }
        },
        child: const Icon(Icons.person),
      );

  /// endregion

}
