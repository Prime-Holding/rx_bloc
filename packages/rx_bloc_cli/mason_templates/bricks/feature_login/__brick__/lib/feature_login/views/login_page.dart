{{> licence.dart }}

{{#enable_social_logins}}
import 'dart:io' show Platform;{{/enable_social_logins}}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';{{#enable_social_logins}}
import '../../lib_social_logins/ui_components/apple_login_widget.dart';
import '../../lib_social_logins/ui_components/facebook_login_widget.dart';
import '../../lib_social_logins/ui_components/google_login_widget.dart';{{/enable_social_logins}}{{#enable_login}}
import '../ui_components/login_form.dart';{{/enable_login}}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.designSystem.spacing.xxl2,
            ),
            child: {{^enable_login}}{{^enable_social_logins}}const {{/enable_social_logins}}{{/enable_login}}Column({{^enable_login}}{{^enable_social_logins}}
              mainAxisAlignment: MainAxisAlignment.center,{{/enable_social_logins}}{{/enable_login}}
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [{{#enable_login}}
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(context.l10n.featureLogin.loginPageTitle,
                          textAlign: TextAlign.center,
                          style: context.designSystem.typography.h1Bold24),
                      SizedBox(height: context.designSystem.spacing.xxxxl),
                      LoginForm(
                        title: context.l10n.featureLogin.loginCredentialsHint,
                      ),{{/enable_login}}{{#enable_social_logins}}
                      SizedBox(height: context.designSystem.spacing.xs1),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Divider(
                                color: context.designSystem.colors.gray),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: context.designSystem.spacing.xs),
                            child: Text(context.l10n.featureLogin.or),
                          ),
                          Expanded(
                            flex: 1,
                            child: Divider(
                                color: context.designSystem.colors.gray),
                          ),
                        ],
                      ),
                      SizedBox(height: context.designSystem.spacing.m),
                      const FacebookLoginWidget(),
                      if (Platform.isIOS)
                        Column(
                          children: [
                            SizedBox(height: context.designSystem.spacing.xs),
                            const AppleLoginWidget(),
                          ],
                        ),
                      SizedBox(height: context.designSystem.spacing.xs),
                      const GoogleLoginWidget(),{{/enable_social_logins}}{{#enable_login}}
                    ],
                  ),
                ),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: context.l10n.featureLogin.dontHaveAccount,
                    style: context.designSystem.typography.h2Reg16
                        .copyWith(color: context.designSystem.colors.gray),
                    children: [
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: context.l10n.featureLogin.signUpLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.designSystem.spacing.xl),{{/enable_login}}{{^enable_login}}{{^enable_social_logins}}
                Center(child: Text('No login option has been selected for the project.',textAlign: TextAlign.center,),),{{/enable_social_logins}}{{/enable_login}}
              ],
            ),
          ),
        ),
      );
}
