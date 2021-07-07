import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test_app/feature_login/blocs/login_bloc.dart';
import 'package:test_app/feature_login/views/login_page.dart';

import '../../mocks/login_bloc_mock.dart';

/// wraps a [LoginPage] in a [Provider] of type [LoginBlocType], creating
/// a mocked bloc depending on the values being tested
Widget loginPageFactory({
  String? username,
  String? password,
  bool? loggedIn,
  bool? showErrors,
  String? error,
  bool? isLoading,
}) =>
    Provider<LoginBlocType>(
      create: (_) => loginBlocMockFactory(
        username: username,
        password: password,
        loggedIn: loggedIn,
        showErrors: showErrors,
        error: error,
        isLoading: isLoading,
      ),
      child: const LoginPage(),
    );
