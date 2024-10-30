{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../ui_components/showcase_feature_button.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [ {{#enable_feature_counter}}
          ShowcaseFeatureButton(
            buttonText: context.l10n.featureShowcase.counterShowcase,
            onPressed: () => context.read<RouterBlocType>().events.push(
                  const CounterRoute(),
                ),
          ),{{/enable_feature_counter}} {{#enable_feature_widget_toolkit}}
          ShowcaseFeatureButton(
            buttonText: context.l10n.featureShowcase.widgetToolkitShowcase,
            onPressed: () => context.read<RouterBlocType>().events.push(
                  const WidgetToolkitRoute(),
                ),
          ), {{/enable_feature_widget_toolkit}} {{#enable_feature_qr_scanner}}
          ShowcaseFeatureButton(
            buttonText: context.l10n.featureShowcase.qrCodeShowcase,
            onPressed: () => context.read<RouterBlocType>().events.push(
                  const QrCodeRoute(),
                ),
          ), {{/enable_feature_qr_scanner}} {{#enable_feature_deeplinks}}
          ShowcaseFeatureButton(
            buttonText: context.l10n.featureShowcase.deepLinkShowcase,
            onPressed: () => context.read<RouterBlocType>().events.push(
                  const DeepLinksRoute(),
                ),
          ), {{/enable_feature_deeplinks}} {{#enable_mfa}}
          ShowcaseFeatureButton(
            buttonText: context.l10n.featureShowcase.mfaShowcase,
            onPressed: () => context.read<RouterBlocType>().events.push(
                  const FeatureMfaRoute(),
                ),
          ), {{/enable_mfa}} {{#enable_feature_otp}}
          ShowcaseFeatureButton(
            buttonText: context.l10n.featureShowcase.otpShowcase,
            onPressed: () => context.read<RouterBlocType>().events.push(
                  const FeatureOtpRoute(),
                ),
          ),{{/enable_feature_otp}}
        ],
      ),
    );
  }
}
