{{> licence.dart }}

import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/onboarding_phone_factory.dart';
import '../stubs.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'onboarding_phone_empty',
      widget: onboardingPhoneFactory(),
    ),
    buildScenario(
      customPumpBeforeTest: (tester) => tester.pump(
        const Duration(microseconds: 300),
      ),
      scenario: 'onboarding_phone_filled',
      widget: onboardingPhoneFactory(
        phoneNumber: Stubs.phone,
        countryCode: Stubs.countryCodeModel,
        showErrors: false,
        phoneSubmitted: Stubs.user,
      ),
    ),
    buildScenario(
      scenario: 'onboarding_phone_loading',
      customPumpBeforeTest: (tester) => tester.pump(
        const Duration(milliseconds: 350),
      ),
      widget: onboardingPhoneFactory(
        isLoading: true,
        phoneNumber: Stubs.phone,
      ),
    ),
    buildScenario(
      scenario: 'onboarding_phone_error',
      widget: onboardingPhoneFactory(
        errors: UnknownErrorModel(
          exception: Exception('Something went wrong'),
        ),
      ),
    ),
  ]);
}
