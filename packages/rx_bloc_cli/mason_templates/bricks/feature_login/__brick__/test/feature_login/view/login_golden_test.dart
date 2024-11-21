import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/login_factory.dart';
import '../stubs.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'login_empty',
      act: animationCustomPump,
      builder: () => loginFactory(
        loggedIn: false,
        showErrors: false,
        isLoading: false,
      ),
    ),
    buildScenario(
      scenario: 'login_filled',
      act: animationCustomPump,
      builder: () => loginFactory(
        email: Stubs.email,
        password: Stubs.password,
      ),
    ),
    buildScenario(
      scenario: 'login_loading',
      act: animationCustomPump,
      customPumpBeforeTest: animationCustomPump,
      builder: () => loginFactory(isLoading: true),
    ),
    buildScenario(
      scenario: 'login_success',
      act: animationCustomPump,
      builder: () => loginFactory(
        isLoading: false,
        loggedIn: true,
        showErrors: false,
      ),
    ),
    buildScenario(
      scenario: 'login_error',
      act: animationCustomPump,
      builder: () => loginFactory(
        showErrors: true,
        errors: UnknownErrorModel(
          exception: Exception('Something went wrong'),
        ),
      ),
    ),
  ]);
}
