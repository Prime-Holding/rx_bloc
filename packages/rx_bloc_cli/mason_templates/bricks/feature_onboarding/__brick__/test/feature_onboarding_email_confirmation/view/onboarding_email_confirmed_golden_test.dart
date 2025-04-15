{{> licence.dart }}

import '../../helpers/golden_helper.dart';
import '../factory/onboarding_email_confirmed_factory.dart';
import '../stubs.dart';

void main() {
  runGoldenTests([
    buildScenario(
      customPumpBeforeTest: (widgetTester) =>
          widgetTester.pump(const Duration(milliseconds: 350)),
      scenario: 'onboarding_email_confirmed_empty',
      widget: onboardingEmailConfirmedFactory(),
    ),
    buildScenario(
      customPumpBeforeTest: (widgetTester) =>
          widgetTester.pump(const Duration(milliseconds: 350)),
      scenario: 'onboarding_email_confirmed_success',
      widget: onboardingEmailConfirmedFactory(
        data: Stubs.user,
      ),
    ),
    buildScenario(
      customPumpBeforeTest: (widgetTester) =>
          widgetTester.pump(const Duration(milliseconds: 350)),
      scenario: 'onboarding_email_confirmed_loading',
      widget: onboardingEmailConfirmedFactory(
        isLoading: true,
      ),
    ),
  ]);
}
