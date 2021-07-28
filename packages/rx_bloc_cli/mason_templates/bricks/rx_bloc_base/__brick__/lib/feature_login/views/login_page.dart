// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../di/login_dependencies.dart';
import '../ui_components/login_form.dart';

class LoginPage extends StatelessWidget implements AutoRouteWrapper {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: LoginDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.loginPageTitle)),
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
                      color: context.designSystem.colors.reverseBackgroundColor,
                    ),
                  ),
                  child: LoginForm(
                    onLoginSuccess: () {
                      context.router.replace(const NotificationsRoute());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
