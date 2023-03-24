{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';{{#enable_apple_auth}}
import '../../lib_auth_apple/di/apple_login_button_with_dependencies.dart';{{/enable_apple_auth}}
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
              ),{{#enable_apple_auth}}
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.designSystem.spacing.xxl,
                    vertical: context.designSystem.spacing.l),
                child: const AppleLoginButtonWithDependencies(),
              ),{{/enable_apple_auth}}
            ],
          ),
        ),
      );
}
