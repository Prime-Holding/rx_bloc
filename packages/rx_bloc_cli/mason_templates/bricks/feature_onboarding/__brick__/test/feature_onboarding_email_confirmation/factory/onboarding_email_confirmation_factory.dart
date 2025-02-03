{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_onboarding_email_confirmation/blocs/onboarding_email_confirmation_bloc.dart';
import 'package:{{project_name}}/feature_onboarding_email_confirmation/views/onboarding_email_confirmation_page.dart';

import '../mock/onboarding_email_confirmation_mock.dart';

/// Change the parameters according the the needs of the test
Widget onboardingEmailConfirmationFactory({
  bool? isLoading,
  ErrorModel? errors,
  String? email,
  bool? isSendNewLinkActive,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<OnboardingEmailConfirmationBlocType>.value(
          value: onboardingEmailConfirmationMockFactory(
            isLoading: isLoading,
            errors: errors,
            email: email,
            isSendNewLinkActive: isSendNewLinkActive,
          ),
        ),
      ], child: const OnboardingEmailConfirmationPage()),
    );
