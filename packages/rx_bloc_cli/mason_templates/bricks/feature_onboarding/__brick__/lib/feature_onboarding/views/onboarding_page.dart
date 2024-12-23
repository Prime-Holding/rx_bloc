{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../ui_components/register_form.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppBar(
          context,
          title: context.l10n.featureOnboarding.registerPageTitle,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.designSystem.spacing.xxl2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RegisterForm(
                  title: context.l10n.featureOnboarding.registerCredentialsHint,
                ),
              ],
            ),
          ),
        ),
      );
}
