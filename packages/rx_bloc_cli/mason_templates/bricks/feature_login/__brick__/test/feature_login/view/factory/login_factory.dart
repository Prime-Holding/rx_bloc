import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_login/blocs/login_bloc.dart';
import 'package:{{project_name}}/feature_login/views/login_page.dart';{{#enable_social_logins}}
import 'package:{{project_name}}/lib_social_logins/blocs/social_login_bloc.dart';{{/enable_social_logins}}

import '../../mock/login_mock.dart';{{#enable_social_logins}}
import '../../mock/social_login_mock.dart';{{/enable_social_logins}}

/// Change the parameters according the the needs of the test
Widget loginFactory({
  String? email,
  String? password,
  bool? loggedIn,
  bool? showErrors,
  bool? isLoading,
  ErrorModel? errors,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          RxBlocProvider<LoginBlocType>(
            create: (_) => loginMockFactory(
              email: email,
              password: password,
              loggedIn: loggedIn,
              showErrors: showErrors,
              isLoading: isLoading,
              errors: errors,
            ),
          ),{{#enable_social_logins}}
          RxBlocProvider<SocialLoginBlocType>(
            create: (_) => socialLoginMockFactory(
              loggedIn: loggedIn,
              isLoading: isLoading,
              errors: errors,
            ),
          ),{{/enable_social_logins}}
        ],
        child: const LoginPage(),
      ),
    );
