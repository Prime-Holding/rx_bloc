import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/login_factory.dart';
import '../stubs.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'login_empty',
      act: _loginActPump,
      builder: () => loginFactory(
        loggedIn: false,
        showErrors: false,
        isLoading: false,
      ),
    ),
    buildScenario(
      scenario: 'login_filled',
      act: _loginActPump,
      builder: () => loginFactory(
        email: Stubs.email,
        password: Stubs.password,
      ),
    ),
    buildScenario(
      scenario: 'login_loading',
      customPumpBeforeTest: animationCustomPump,
      builder: () => loginFactory(isLoading: true),
    ),
    buildScenario(
      scenario: 'login_success',
      act: _loginActPump,
      builder: () => loginFactory(
        isLoading: false,
        loggedIn: true,
        showErrors: false,
      ),
    ),
    buildScenario(
      scenario: 'login_error',
      act: _loginActPump,
      builder: () => loginFactory(
        showErrors: true,
        errors: UnknownErrorModel(
          exception: Exception('Something went wrong'),
        ),
      ),
    ),
  ]);
}

Future<void> _loginActPump(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 1000));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 1000));
}
