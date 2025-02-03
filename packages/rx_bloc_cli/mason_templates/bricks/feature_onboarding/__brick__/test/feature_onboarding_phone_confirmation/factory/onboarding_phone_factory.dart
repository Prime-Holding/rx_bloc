{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/base/models/country_code_model.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/feature_onboarding_phone_confirmation/blocs/onboarding_phone_bloc.dart';
import 'package:{{project_name}}/feature_onboarding_phone_confirmation/views/onboarding_phone_page.dart';

import '../mock/onboarding_phone_mock.dart';

/// Change the parameters according the the needs of the test
Widget onboardingPhoneFactory({
  bool? isLoading,
  UserModel? phoneSubmitted,
  CountryCodeModel? countryCode,
  String? phoneNumber,
  ErrorModel? errors,
  bool? showErrors,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<OnboardingPhoneBlocType>.value(
          value: onboardingPhoneMockFactory(
            isLoading: isLoading,
            phoneSubmitted: phoneSubmitted,
            countryCode: countryCode,
            phoneNumber: phoneNumber,
            errors: errors,
            showErrors: showErrors,
          ),
        ),
      ], child: const OnboardingPhonePage()),
    );
