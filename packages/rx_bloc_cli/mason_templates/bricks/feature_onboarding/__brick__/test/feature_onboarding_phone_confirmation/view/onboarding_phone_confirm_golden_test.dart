{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/onboarding_phone_confirm_factory.dart';

void main() {
  group('onboarding phone confirm', () {
    runGoldenTests([
      buildScenario(
        scenario: 'onboarding_phone_confirm_empty',
        widget: onboardingPhoneConfirmFactory(),
      ),
      buildScenario(
        scenario: 'onboarding_phone_confirm_error',
        widget: onboardingPhoneConfirmFactory(
          errors: UnknownErrorModel(
            exception: Exception('Something went wrong'),
          ),
        ),
      ),
    ]);
  });
}
