{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';

import 'package:{{project_name}}/feature_onboarding_phone_confirmation/blocs/onboarding_phone_confirm_bloc.dart';
import 'package:{{project_name}}/feature_onboarding_phone_confirmation/views/onboarding_phone_confirm_page.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../mock/onboarding_phone_confirm_mock.dart';
import '../mock/onboarding_phone_sms_code_service_mock.dart';

/// Change the parameters according the the needs of the test
Widget onboardingPhoneConfirmFactory({
  ErrorModel? errors,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        Provider<SmsCodeService>.value(
          value: createSmsCodeService(),
        ),
        RxBlocProvider<OnboardingPhoneConfirmBlocType>.value(
          value: onboardingPhoneConfirmMockFactory(
            errors: errors,
          ),
        ),
      ], child: const OnboardingPhoneConfirmPage()),
    );
