{{> licence.dart }}

{{#enable_social_logins}}
import 'dart:io' show Platform;{{/enable_social_logins}}

import 'package:flutter/material.dart';{{#enable_feature_onboarding}}
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:widget_toolkit/ui_components.dart';{{/enable_feature_onboarding}}

import '../../app_extensions.dart';
import '../../base/common_ui_components/custom_app_bar.dart';{{#enable_feature_onboarding}}
import '../../base/extensions/async_snapshot_extensions.dart';{{/enable_feature_onboarding}}{{#enable_social_logins}}
import '../../lib_social_logins/ui_components/apple_login_widget.dart';
import '../../lib_social_logins/ui_components/facebook_login_widget.dart';
import '../../lib_social_logins/ui_components/google_login_widget.dart';{{/enable_social_logins}}{{#enable_login}}{{#enable_feature_onboarding}}
import '../blocs/login_bloc.dart';{{/enable_feature_onboarding}}
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
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
                ),{{#enable_feature_onboarding}}
                RxBlocBuilder<LoginBlocType, bool>(
                  state: (bloc) => bloc.states.isLoading,
                  builder: (context, isLoading, bloc) => GradientFillButton(
                    onPressed: bloc.events.goToRegistration,
                    state: isLoading.isLoading
                        ? ButtonStateModel.disabled
                        : ButtonStateModel.enabled,
                    text: context.l10n.featureOnboarding.registerPageTitle,
                  ),
                ),{{/enable_feature_onboarding}}
              ],
            ),
          ),
        ),
      );
}
