{{> licence.dart }}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../../base/utils/helpers.dart';
import '../blocs/notifications_bloc.dart';
import '../di/notifications_dependencies.dart';

class NotificationsPage extends StatelessWidget implements AutoRouteWrapper {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: NotificationsDependencies.from(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.featureNotifications.notificationPageTitle,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () => showAdaptiveDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: _buildInfoCard(context),
                  ),
                ),
                icon: Icon(context.designSystem.icons.info),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? MediaQuery.of(context).size.width / 4 : 20,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton(
                      context,
                      context.l10n.featureNotifications
                          .notificationPermissionRequestText,
                      () => context
                          .read<NotificationsBlocType>()
                          .events
                          .requestNotificationPermissions(),
                    ),
                    _buildButton(
                      context,
                      context.l10n.featureNotifications.notificationShowText,
                      () => context
                          .read<NotificationsBlocType>()
                          .events
                          .sendMessage('This is a notification!'),
                    ),
                    _buildButton(
                      context,
                      context.l10n.featureNotifications
                          .notificationShowDelayedText,
                      () => context
                          .read<NotificationsBlocType>()
                          .events
                          .sendMessage(
                            'This is a delayed notification!',
                            delay: 5,
                          ),
                    ),
                    RxBlocListener<NotificationsBlocType, bool>(
                      state: (bloc) => bloc.states.permissionsAuthorized,
                      listener: (context, authorized) async {
                        if (authorized) return;

                        // If not authorized, show a dialog popup
                        await showAdaptiveDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(
                              context.l10n.featureNotifications
                                  .notificationsPermissionsDenied,
                              textAlign: TextAlign.center,
                            ),
                            actions: <Widget>[
                              Center(
                                child: TextButton(
                                  onPressed: () => context.router.pop(),
                                  child: Text(
                                    context.l10n.ok,
                                    style: context.designSystem.typography
                                        .fadedButtonText,
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
            ),
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
        child: SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: PrimaryButton(
              onPressed: () => onPressed?.call(),
              child: Text(
                label,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );

  Widget _buildInfoCard(BuildContext context) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        child: Container(
          width: MediaQuery.of(context).size.width / (kIsWeb ? 3 : 1),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.featureNotifications.notificationsPageDescription,
                textAlign: TextAlign.center,
              ),
              const Divider(
                height: 30,
                thickness: 2,
                indent: 120,
                endIndent: 120,
              ),
              Text(
                context.l10n.featureNotifications.notificationsPageConfig,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () => context.router.pop(),
                  child: Text(context.l10n.close),
                ),
              ),
            ],
          ),
        ),
      );

  /// endregion
}
