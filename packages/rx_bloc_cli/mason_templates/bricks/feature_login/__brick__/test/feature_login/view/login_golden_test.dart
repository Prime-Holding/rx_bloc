import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/login_factory.dart';
import '../stubs.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'login_empty',
      customPumpBeforeTest: animationCustomPump,
      widget: loginFactory(
        loggedIn: false,
        showErrors: false,
        isLoading: false,
      ),
    ),
    buildScenario(
      scenario: 'login_filled',
      customPumpBeforeTest: animationCustomPump,
      widget: loginFactory(
        email: Stubs.email,
        password: Stubs.password,
      ),
    ),
    buildScenario(
      scenario: 'login_success',
      customPumpBeforeTest: animationCustomPump,
      widget: loginFactory(
        isLoading: false,
        loggedIn: true,
        showErrors: false,
      ),
    ),
    buildScenario(
      scenario: 'login_error',
      customPumpBeforeTest: animationCustomPump,
      widget: loginFactory(
        showErrors: true,
        errors: UnknownErrorModel(
          exception: Exception('Something went wrong'),
        ),
      ),
    )
  ]);
}
