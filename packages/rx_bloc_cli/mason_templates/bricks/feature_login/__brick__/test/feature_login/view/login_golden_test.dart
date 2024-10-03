import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/login_factory.dart';
import '../stubs.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget:
            loginFactory(loggedIn: false, showErrors: false, isLoading: false),
        //example: Stubs.emptyList
        scenario: Scenario(name: 'login_empty')),
    generateDeviceBuilder(
        widget: loginFactory(email: Stubs.email, password: Stubs.password),
        //example: Stubs.emptyList
        scenario: Scenario(name: 'login_filled')),
    generateDeviceBuilder(
        widget:
            loginFactory(isLoading: false, loggedIn: true, showErrors: false),
        //example: Stubs.listWithTwoItems
        scenario: Scenario(name: 'login_success')),
    generateDeviceBuilder(
        widget: loginFactory(isLoading: true), //loading
        scenario: Scenario(name: 'login_loading')),
    generateDeviceBuilder(
        widget: loginFactory(
            showErrors: true,
            errors: UnknownErrorModel(
                exception: Exception('Something went wrong'))), //error
        scenario: Scenario(name: 'login_error'))
  ]);
}
