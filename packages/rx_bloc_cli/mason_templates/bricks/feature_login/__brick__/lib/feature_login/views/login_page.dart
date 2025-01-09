{{> licence.dart }}

{{#enable_social_logins}}
import 'dart:io' show Platform;{{/enable_social_logins}}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../blocs/login_bloc.dart';
import '../../app_extensions.dart';
import '../../base/extensions/async_snapshot_extensions.dart';{{#enable_social_logins}}
import '../../lib_social_logins/ui_components/apple_login_widget.dart';
import '../../lib_social_logins/ui_components/facebook_login_widget.dart';
import '../../lib_social_logins/ui_components/google_login_widget.dart';{{/enable_social_logins}}{{#enable_login}}
import '../ui_components/login_form.dart';
import '../ui_components/sign_up_button.dart';{{/enable_login}}

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
                  child: Center(
                    child: SingleChildScrollView(
                      child:  Column(
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
                                  child: Divider(
                                  color: context.designSystem.colors.dividerColor),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                  horizontal: context.designSystem.spacing.xs),
                                  child: Text(context.l10n.featureLogin.or),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Divider(
                                  color: context.designSystem.colors.dividerColor),
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
                  ),
                ),
                RxBlocBuilder<LoginBlocType, bool>(
                  state: (bloc) => bloc.states.isLoading,
                  builder: (context, isLoading, bloc) => SignUpButton(
                    isLoading: isLoading.isLoading,
                    onPressed: bloc.events.goToRegistration,
                  ),
                ),
                SizedBox(height: context.designSystem.spacing.xl),{{/enable_login}}{{^enable_login}}{{^enable_social_logins}}
                Center(child: Text(context.l10n.featureLogin.noLoginOption,textAlign: TextAlign.center,),),{{/enable_social_logins}}{{/enable_login}}
              ],
            ),
          ),
        ),
      );
}
