import 'package:testapp/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/onboarding_factory.dart';
import '../stubs.dart';

void main() {
  runGoldenTests([
    buildScenario(
      customPumpBeforeTest: (widgetTester) => widgetTester.pump(
        const Duration(milliseconds: 350),
      ),
      scenario: 'onboarding_success',
      widget: onboardingFactory(
        email: Stubs.email,
        password: Stubs.password,
        registered: Stubs.user,
      ),
    ),
    buildScenario(
      customPumpBeforeTest: (widgetTester) => widgetTester.pump(
        const Duration(milliseconds: 350),
      ),
      scenario: 'onboarding_loading',
      widget: onboardingFactory(
        isLoading: true,
      ),
    ),
    buildScenario(
      scenario: 'onboarding_error',
      widget: onboardingFactory(
        errors: UnknownErrorModel(
          exception: Exception('Something went wrong'),
        ),
      ),
    ),
  ]);
}
