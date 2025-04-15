{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/onboarding_phone_confirm_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'onboarding_phone_confirmation_empty',
      widget: onboardingPhoneConfirmFactory(),
      customPumpBeforeTest: (tester) =>
          tester.pumpAndSettle(const Duration(seconds: 2)),
    ),
    buildScenario(
        scenario: 'onboarding_phone_confirmation_error',
        widget: onboardingPhoneConfirmFactory(
          errors: UnknownErrorModel(
            exception: Exception('Something went wrong'),
          ),
        ),
        customPumpBeforeTest: (tester) =>
            tester.pumpAndSettle(const Duration(seconds: 2))),
  ]);
}
