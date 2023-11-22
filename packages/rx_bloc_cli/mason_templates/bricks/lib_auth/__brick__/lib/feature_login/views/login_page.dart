{{> licence.dart }}

{{#enable_social_logins}}
import 'dart:io' show Platform;{{/enable_social_logins}}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';{{#enable_social_logins}}
import '../../lib_social_logins/ui_components/apple_login_widget.dart';
import '../../lib_social_logins/ui_components/facebook_login_widget.dart';
import '../../lib_social_logins/ui_components/google_login_widget.dart';{{/enable_social_logins}}{{#enable_login}}
import '../ui_components/login_form.dart';{{/enable_login}}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppBar(
          context,
          title: context.l10n.featureLogin.loginPageTitle,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.designSystem.spacing.xxl2,
            ),
            child: {{^enable_login}}{{^enable_social_logins}}const {{/enable_social_logins}}{{/enable_login}}Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [{{#enable_login}}
                LoginForm(
                  title: context.l10n.featureLogin.loginCredentialsHint,
                ),{{/enable_login}}{{#enable_social_logins}}
                SizedBox(height: context.designSystem.spacing.xs),
                const FacebookLoginWidget(),
                if (Platform.isIOS)
                  Column(
                    children: [
                      SizedBox(height: context.designSystem.spacing.xs),
                      const AppleLoginWidget(),
                    ],
                  ),
                SizedBox(height: context.designSystem.spacing.xs),
                const GoogleLoginWidget(),{{/enable_social_logins}}{{^enable_login}}{{^enable_social_logins}}
                Center(child: Text('No login option has been selected for the project.',textAlign: TextAlign.center,),),{{/enable_social_logins}}{{/enable_login}}
              ],
            ),
          ),
        ),
      );
}
