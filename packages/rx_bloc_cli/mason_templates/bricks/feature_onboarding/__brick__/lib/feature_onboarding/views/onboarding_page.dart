{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../ui_components/register_form.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => RxUnfocuser(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: customAppBar(context),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.designSystem.spacing.xxl2,
              ),
              child: RegisterForm(
                title: context.l10n.featureOnboarding.registerPageTitle,
                description:
                    context.l10n.featureOnboarding.registerCredentialsHint,
              ),
            ),
          ),
        ),
      );
}
