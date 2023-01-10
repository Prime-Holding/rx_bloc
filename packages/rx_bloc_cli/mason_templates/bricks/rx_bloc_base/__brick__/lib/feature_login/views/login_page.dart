{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/routers/router.dart';
import '../ui_components/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.featureLogin.loginPageTitle)),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  child: LoginForm(
                    onLoginSuccess: () => const CounterRoute().go(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
