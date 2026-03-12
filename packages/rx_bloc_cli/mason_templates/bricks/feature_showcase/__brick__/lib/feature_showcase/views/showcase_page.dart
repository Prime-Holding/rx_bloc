{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_divider.dart';{{#enable_in_app_notifications}}
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../feature_in_app_notifications/ui_components/notification_action_button.dart';{{/enable_in_app_notifications}}
import '../../base/common_ui_components/app_list_tile.dart';
import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/router.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold( {{#enable_in_app_notifications}}
          appBar: customAppBar(context, actions: [
            Padding(
              padding: EdgeInsets.only(right:context.designSystem.spacing.s),
              child: const NotificationActionButton(),
            ),
          ]),{{/enable_in_app_notifications}}
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  context.l10n.showcaseTitle,
                  style: context.designSystem.typography.textTheme.headlineSmall,
                ),
                titlePadding: EdgeInsetsDirectional.only(
                  start: context.designSystem.spacing.l,
                  bottom: context.designSystem.spacing.l,
                ),
                centerTitle: false,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final feature = context.features[index];

                  return AppListTile(
                    featureTitle: feature.title,
                    featureSubtitle: feature.subtitle,
                     onTap: () =>
                        GoRouter.of(context).go(feature.route.routeLocation),
                    icon: feature.icon,
                  );
                },
                childCount: context.features.length,
              ),
            ),
          ],
        ),
      );
}

extension on BuildContext {
  List<({String title, String subtitle, RouteDataModel route, Icon icon})>
      get features => [
            (
              title: l10n.notificationPageTitle,
              subtitle: l10n.notificationPageSubtitle,
              route: const NotificationsRoute(),
              icon: designSystem.icons.notifications,
            ),
            {{#enable_feature_counter}}(
              title: l10n.counterShowcase,
              subtitle: l10n.counterShowcaseDescription,
              route: const CounterRoute(),
              icon: designSystem.icons.calculateIcon,
            ), {{/enable_feature_counter}} {{#enable_feature_widget_toolkit}}
            (
              title: l10n.widgetToolkitShowcase,
              subtitle: l10n.widgetToolkitShowcaseDescription,
              route: const WidgetToolkitRoute(),
              icon: designSystem.icons.widgetIcon,
            ), {{/enable_feature_widget_toolkit}} {{#enable_feature_qr_scanner}}
            (
              title: l10n.qrCodeShowcase,
              subtitle: l10n.qrCodeShowcaseDescription,
              route: const QrCodeRoute(),
              icon: designSystem.icons.qrCode,
            ), {{/enable_feature_qr_scanner}} {{#enable_feature_deeplinks}}
            (
              title: l10n.deepLinkShowcase,
              subtitle: l10n.deepLinkShowcaseDescription,
              route: const DeepLinksRoute(),
              icon: designSystem.icons.linkIcon,
            ), {{/enable_feature_deeplinks}} {{#enable_mfa}}
            (
              title: l10n.mfaShowcase,
              subtitle: l10n.mfaShowcaseDescription,
              route: const FeatureMfaRoute(),
              icon: designSystem.icons.pin,
            ), {{/enable_mfa}} {{#enable_feature_otp}}
            (
              title: l10n.otpShowcase,
              subtitle: l10n.otpShowcaseDescription,
              route: const FeatureOtpRoute(),
              icon: designSystem.icons.otp,
            ), {{/enable_feature_otp}}
          ];
}
