{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';{{#enable_social_logins}}
import '../../lib_social_logins/ui_components/apple_login_widget.dart';
import '../../lib_social_logins/ui_components/google_login_widget.dart';
import '../../lib_social_logins/ui_components/facebook_login_widget.dart';{{/enable_social_logins}}
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
              ),{{#enable_social_logins}}
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.designSystem.spacing.xxl,
                    vertical: context.designSystem.spacing.l,
                ),
                child: const AppleLoginWidget(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.designSystem.spacing.xxl,
                    vertical: context.designSystem.spacing.l,
                ),
                child: const GoogleLoginWidget(),

                Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.designSystem.spacing.xxl,
                    vertical: context.designSystem.spacing.l,
                ),
                child: const FacebookLoginWidget(),
              ),
              ),{{/enable_social_logins}}
            ],
          ),
        ),
      );
}
