{{> licence.dart }}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/utils/helpers.dart';
import '../../lib_router/router.dart';
import '../blocs/notifications_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(
          context,
          title: context.l10n.featureNotifications.notificationPageTitle,
          actions: [
            IconButton(
              onPressed: () => showBlurredBottomSheet(
                context:
                    context.read<AppRouter>().rootNavigatorKey.currentContext ??
                        context,
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
            padding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? MediaQuery.of(context).size.width / 4 : 20,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.designSystem.spacing.xs1,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlineFillButton(
                      text: context.l10n.featureNotifications
                          .notificationPermissionRequestText,
                      onPressed: () => context
                          .read<NotificationsBlocType>()
                          .events
                          .requestNotificationPermissions(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.designSystem.spacing.s,
                      ),
                      child: OutlineFillButton(
                        text: context
                            .l10n.featureNotifications.notificationShowText,
                        onPressed: () => context
                            .read<NotificationsBlocType>()
                            .events
                            .sendMessage(context.l10n.featureNotifications
                                .notificationsMessage),
                      ),
                    ),
                    OutlineFillButton(
                      text: context.l10n.featureNotifications
                          .notificationShowDelayedText,
                      onPressed: () => context
                          .read<NotificationsBlocType>()
                          .events
                          .sendMessage(
                            context
                                .l10n.featureNotifications.notificationsDelayed,
                            delay: 5,
                          ),
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
}
