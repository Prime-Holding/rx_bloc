{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/router.dart';
import '../ui_components/showcase_feature_button.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final features = getFeatures(context);
    return Center(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return ShowcaseFeatureButton(
            featureTitle: feature.title,
            featureSubtitle: feature.subtitle,
            onTap: () =>
                context.read<RouterBlocType>().events.push(feature.route),
            icon: feature.icon,
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: context.designSystem.spacing.m,
          indent: context.designSystem.spacing.m,
          endIndent: context.designSystem.spacing.m,
        ),
      ),
    );
  }
}

List<({String title, String subtitle, RouteDataModel route, Icon icon})>
    getFeatures(BuildContext context) {
  return [
    ( {{#enable_feature_counter}}
      title: context.l10n.featureShowcase.counterShowcase,
      subtitle: context.l10n.featureShowcase.counterShowcaseDescription,
      route: const CounterRoute(),
      icon: context.designSystem.icons.calculateIcon,
    ), {{/enable_feature_counter}} {{#enable_feature_widget_toolkit}}
    (
      title: context.l10n.featureShowcase.widgetToolkitShowcase,
      subtitle: context.l10n.featureShowcase.widgetToolkitShowcaseDescription,
      route: const WidgetToolkitRoute(),
      icon: context.designSystem.icons.widgetIcon,
    ), {{/enable_feature_widget_toolkit}} {{#enable_feature_qr_scanner}}
    (
      title: context.l10n.featureShowcase.qrCodeShowcase,
      subtitle: context.l10n.featureShowcase.qrCodeShowcaseDescription,
      route: const QrCodeRoute(),
      icon: context.designSystem.icons.qrCode,
    ), {{/enable_feature_qr_scanner}} {{#enable_feature_deeplinks}}
    (
      title: context.l10n.featureShowcase.deepLinkShowcase,
      subtitle: context.l10n.featureShowcase.deepLinkShowcaseDescription,
      route: const DeepLinksRoute(),
      icon: context.designSystem.icons.linkIcon,
    ), {{/enable_feature_deeplinks}} {{#enable_mfa}}
    (
      title: context.l10n.featureShowcase.mfaShowcase,
      subtitle: context.l10n.featureShowcase.mfaShowcaseDescription,
      route: const FeatureMfaRoute(),
      icon: context.designSystem.icons.pin,
    ), {{/enable_mfa}} {{#enable_feature_otp}}
    (
      title: context.l10n.featureShowcase.otpShowcase,
      subtitle: context.l10n.featureShowcase.otpShowcaseDescription,
      route: const FeatureOtpRoute(),
      icon: context.designSystem.icons.otp,
    ), {{/enable_feature_otp}}
  ];
}
