{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_divider.dart';
import '../../base/common_ui_components/app_list_tile.dart';
import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/router.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  context.l10n.featureShowcase.showcaseTitle,
                  style: context.designSystem.typography.h1Bold20,
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
                        GoRouter.of(context).push(feature.route.routeLocation),
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
              title: l10n.featureNotifications.notificationPageTitle,
              subtitle: l10n.featureNotifications.notificationPageSubtitle,
              route: const NotificationsRoute(),
              icon: designSystem.icons.notifications,
            ),
            {{#enable_feature_counter}}(
              title: l10n.featureShowcase.counterShowcase,
              subtitle: l10n.featureShowcase.counterShowcaseDescription,
              route: const CounterRoute(),
              icon: designSystem.icons.calculateIcon,
            ), {{/enable_feature_counter}} {{#enable_feature_widget_toolkit}}
            (
              title: l10n.featureShowcase.widgetToolkitShowcase,
              subtitle: l10n.featureShowcase.widgetToolkitShowcaseDescription,
              route: const WidgetToolkitRoute(),
              icon: designSystem.icons.widgetIcon,
            ), {{/enable_feature_widget_toolkit}} {{#enable_feature_qr_scanner}}
            (
              title: l10n.featureShowcase.qrCodeShowcase,
              subtitle: l10n.featureShowcase.qrCodeShowcaseDescription,
              route: const QrCodeRoute(),
              icon: designSystem.icons.qrCode,
            ), {{/enable_feature_qr_scanner}} {{#enable_feature_deeplinks}}
            (
              title: l10n.featureShowcase.deepLinkShowcase,
              subtitle: l10n.featureShowcase.deepLinkShowcaseDescription,
              route: const DeepLinksRoute(),
              icon: designSystem.icons.linkIcon,
            ), {{/enable_feature_deeplinks}} {{#enable_mfa}}
            (
              title: l10n.featureShowcase.mfaShowcase,
              subtitle: l10n.featureShowcase.mfaShowcaseDescription,
              route: const FeatureMfaRoute(),
              icon: designSystem.icons.pin,
            ), {{/enable_mfa}} {{#enable_feature_otp}}
            (
              title: l10n.featureShowcase.otpShowcase,
              subtitle: l10n.featureShowcase.otpShowcaseDescription,
              route: const FeatureOtpRoute(),
              icon: designSystem.icons.otp,
            ), {{/enable_feature_otp}}
          ];
}
