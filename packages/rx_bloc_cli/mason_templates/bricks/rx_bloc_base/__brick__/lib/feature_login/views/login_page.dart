{{> licence.dart }}

import 'package:flutter/material.dart';
{{#enable_facebook_auth}}
import '../../lib_auth_facebook/di/facebook_auth_button_with_dependencies.dart';{{/enable_facebook_auth}}
import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../ui_components/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(
          context,
          title: context.l10n.featureLogin.loginPageTitle,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: context.designSystem.spacing.xxxxl300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      context.designSystem.spacing.xsss,
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  child: LoginForm(
                    title: context.l10n.featureLogin.loginCredentialsHint,
                  ),
                ),
              ),
{{#enable_facebook_auth}}
const FacebookAuthButtonWithDependencies(),
{{/enable_facebook_auth}}
            ],
          ),
        ),
      );
}
