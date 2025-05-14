{{> licence.dart }}

import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/onboarding_email_confirmation_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'onboarding_email_confirmation_success',
      widget: onboardingEmailConfirmationFactory(),
    ),
    buildScenario(
      scenario: 'onboarding_email_confirmation_loading',
      customPumpBeforeTest: (tester) =>
          tester.pump(const Duration(microseconds: 350)),
      widget: onboardingEmailConfirmationFactory(
        isLoading: true,
        email: 'test@example.com',
      ),
    ),
    buildScenario(
      scenario: 'onboarding_email_confirmation_error',
      widget: onboardingEmailConfirmationFactory(
        errors: UnknownErrorModel(
          exception: Exception('Something went wrong'),
        ),
      ),
    ),
  ]);
}
