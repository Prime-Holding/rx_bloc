{{> licence.dart }}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_list_tile.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/models/notification_model.dart';
import '../../lib_router/router.dart';
import '../blocs/notifications_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(
          context,
          title: context.l10n.featureNotifications.notificationPageTitle,
          actions: [
            IconButton(
              onPressed: () => showBlurredBottomSheet(
                context: AppRouter.rootNavigatorKey.currentContext ?? context,
                builder: (BuildContext context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.featureNotifications
                          .notificationsPageDescription,
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
                  ],
                ),
              ),
              icon: Icon(context.designSystem.icons.info),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: context.designSystem.spacing.l,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppListTile(
                  featureTitle: context.l10n.featureNotifications
                      .notificationPermissionRequestText,
                  trailing: const SizedBox(),
                  icon: const Icon(Icons.notification_add_outlined),
                  onTap: () => context
                      .read<NotificationsBlocType>()
                      .events
                      .requestNotificationPermissions(),
                ),
                AppListTile(
                  featureTitle:
                      context.l10n.featureNotifications.notificationShowText,
                  trailing: const SizedBox(),
                  icon: const Icon(Icons.notifications_active_outlined),
                  onTap: () => context
                      .read<NotificationsBlocType>()
                      .events
                      .sendMessage(context
                          .l10n.featureNotifications.notificationsMessage),
                ),
                AppListTile(
                  featureTitle: context
                      .l10n.featureNotifications.notificationShowDelayedText,
                  trailing: const SizedBox(),
                  icon: const Icon(Icons.notifications_paused_outlined),
                  onTap: () => context
                      .read<NotificationsBlocType>()
                      .events
                      .sendMessage(
                        context.l10n.featureNotifications.notificationsDelayed,
                        delay: 5,
                      ),
                ),
                AppListTile(
                  featureTitle: context.l10n.featureNotifications
                      .notificationShowRedirectingText,
                  trailing: const SizedBox(),
                  icon: const Icon(Icons.circle_notifications_outlined),
                  onTap: () => context
                      .read<NotificationsBlocType>()
                      .events
                      .sendMessage(
                          context
                              .l10n.featureNotifications.notificationRedirecing,
                          delay: 5,
                          data: NotificationModel(
                            type: NotificationModelType.dashboard,
                            id: '1',
                          ).toJson()),
                ),
                RxBlocListener<NotificationsBlocType, bool>(
                  state: (bloc) => bloc.states.permissionsAuthorized,
                  listener: (ctx, authorized) async {
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
                              onPressed: () => context.pop(),
                              child: Text(
                                context.l10n.ok,
                                style: context
                                    .designSystem.typography.fadedButtonText,
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
      );
}
