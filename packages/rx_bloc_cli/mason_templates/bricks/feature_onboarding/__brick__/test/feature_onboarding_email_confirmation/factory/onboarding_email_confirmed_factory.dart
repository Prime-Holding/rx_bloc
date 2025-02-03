{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/feature_onboarding_email_confirmation/blocs/onboarding_email_confirmed_bloc.dart';
import 'package:{{project_name}}/feature_onboarding_email_confirmation/views/onboarding_email_confirmed_page.dart';

import '../mock/onboarding_email_confirmed_mock.dart';

/// Change the parameters according the the needs of the test
Widget onboardingEmailConfirmedFactory({
  bool? isLoading,
  ErrorModel? errors,
  UserModel? data,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<OnboardingEmailConfirmedBlocType>.value(
          value: onboardingEmailConfirmedMockFactory(
            isLoading: isLoading,
            errors: errors,
            data: data,
          ),
        ),
      ], child: const OnboardingEmailConfirmedPage()),
    );
