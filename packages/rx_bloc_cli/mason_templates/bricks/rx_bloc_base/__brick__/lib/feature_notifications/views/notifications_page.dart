{{> licence.dart }}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/app/config/app_constants.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/app_list_tile.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../lib_router/router.dart';
import '../blocs/notifications_bloc.dart';
import '../ui_components/push_token_widget.dart';

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
                SizedBox(
                  height: context.designSystem.spacing.m,
                ),
              Padding(
                padding: EdgeInsets.only(
                  left: context.designSystem.spacing.l,
                  right: context.designSystem.spacing.l,
                ),
                child: PushTokenWidget(
                    label: context
                        .l10n.featureNotifications.notificationConsoleLabel,
                    value: firebaseProjectUrl),
              ),
              SizedBox(
                height: context.designSystem.spacing.l,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: context.designSystem.spacing.l,
                  right: context.designSystem.spacing.l,
                ),
                child: RxResultBuilder<NotificationsBlocType, String>(
                  state: (bloc) => bloc.states.pushToken,
                  buildSuccess: (context, pushToken, bloc) => PushTokenWidget(
                    label: context
                        .l10n.featureNotifications.notificationTokenLabel,
                    value: pushToken,
                    key: const Key('pushTokenSuccessWidget'),
                  ),
                  buildError: (context, error, bloc) => PushTokenWidget(
                    label: context
                        .l10n.featureNotifications.notificationTokenLabel,
                    error: context.l10n.error.notImplemented,
                    key: const Key('pushTokenErrorWidget'),
                  ),
                  buildLoading: (context, bloc) => PushTokenWidget(
                    label: context
                        .l10n.featureNotifications.notificationTokenLabel,
                    value: null,
                    key: const Key('pushTokenLoadingWidget'),
                  ),
                ),
              ),
              AppErrorModalWidget<NotificationsBlocType>(
                errorState: (bloc) => bloc.states.errors,
                onRetry: (_, __) => context
                    .read<NotificationsBlocType>()
                    .events
                    .fetchPushToken(),
                onCancel: () =>
                    Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      );
}
