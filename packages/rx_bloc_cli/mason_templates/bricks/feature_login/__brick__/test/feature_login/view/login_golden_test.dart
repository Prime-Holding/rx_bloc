import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/login_factory.dart';
import '../stubs.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'empty',
      widget: loginFactory(
        loggedIn: false,
        showErrors: false,
        isLoading: false,
      ),
    ),
    buildScenario(
      scenario: 'filled',
      widget: loginFactory(
        email: Stubs.email,
        password: Stubs.password,
      ),
    ),
    buildScenario(
      scenario: 'loading',
      customPumpBeforeTest: animationCustomPump,
      widget: loginFactory(isLoading: true),
    ),
    buildScenario(
      scenario: 'success',
      widget: loginFactory(
        isLoading: false,
        loggedIn: true,
        showErrors: false,
      ),
    ),
    buildScenario(
      scenario: 'error',
      act: animationCustomPump,
      devices: [defaultDevices.first],
      widget: loginFactory(
        showErrors: true,
        errors: UnknownErrorModel(
          exception: Exception('Something went wrong'),
        ),
      ),
    ),
  ]);
}
