// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/utils/helpers.dart';
import '../blocs/send_notifications_bloc.dart';
import '../di/notifications_dependencies.dart';

class NotificationsPage extends StatelessWidget implements AutoRouteWrapper {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: NotificationsDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.notificationPageTitle),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                context,
                'Request notification permissions',
                () => RxBlocProvider.of<SendNotificationsBlocType>(context)
                    .events
                    .requestNotificationPermissions(),
              ),
              _buildButton(
                context,
                'Show notification',
                () => RxBlocProvider.of<SendNotificationsBlocType>(context)
                    .events
                    .sendMessage('This is a notification!'),
              ),
              _buildButton(
                context,
                'Show notification after 5 seconds',
                () => RxBlocProvider.of<SendNotificationsBlocType>(context)
                    .events
                    .sendMessage('This is a delayed notification!', delay: 5),
              ),
              RxBlocListener<SendNotificationsBlocType, bool>(
                state: (bloc) => bloc.states.permissionsAuthorized,
                listener: (context, authorized) async {
                  if (authorized ?? false) return;

                  // If not authorized, show a dialog popup
                  await showAdaptiveDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Container(
                        child: Text(
                          context.l10n.notificationsPermissionsDenied,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      actions: <Widget>[
                        Center(
                          child: TextButton(
                            onPressed: () => context.router.pop(),
                            child: Text(
                              context.l10n.ok,
                              style:
                                  context.designSystem.typography.buttonFaded,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );

  /// region Builders

  Widget _buildButton(
    BuildContext context,
    String label, [
    Function()? onPressed,
  ]) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: OutlinedButton(
            onPressed: () => onPressed?.call(),
            child: Text(
              label,
              style: context.designSystem.typography.buttonFaded,
            ),
          ),
        ),
      );

  /// endregion
}
