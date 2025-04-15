import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:testapp/base/models/errors/error_model.dart';
import 'package:testapp/base/models/user_with_auth_token_model.dart';
import 'package:testapp/feature_onboarding/blocs/onboarding_bloc.dart';
import 'package:testapp/feature_onboarding/views/onboarding_page.dart';

import '../mock/onboarding_mock.dart';

/// Change the parameters according the the needs of the test
Widget onboardingFactory({
  String? email,
  String? password,
  UserWithAuthTokenModel? registered,
  bool? showFieldErrors,
  bool? isLoading,
  ErrorModel? errors,
  ErrorModel? resumeOnboardingErrors,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<OnboardingBlocType>.value(
          value: onboardingMockFactory(
            email: email,
            password: password,
            registered: registered,
            showFieldErrors: showFieldErrors,
            isLoading: isLoading,
            errors: errors,
            resumeOnboardingErrors: resumeOnboardingErrors,
          ),
        ),
      ], child: const OnboardingPage()),
    );
