{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../../lib_auth/blocs/user_account_bloc.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: context.designSystem.icons.logoutIcon,
              onPressed: () =>
                  context.read<UserAccountBlocType>().events.logout(),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.designSystem.spacing.xl0,
              ),
              child: PrimaryButton(
                child: Text(
                  context.l10n.featureNotifications.notificationPageTitle,
                ),
                onPressed: () => context
                    .read<RouterBlocType>()
                    .events
                    .pushTo(const NotificationsRoute()),
              ),
            ),
          ],
        ),
      );
}
