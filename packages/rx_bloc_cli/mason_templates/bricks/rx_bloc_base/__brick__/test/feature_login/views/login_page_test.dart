import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../../helpers/stubs.dart';
import 'factories/login_page_factory.dart';

void main() {
  group(
    'LoginPage golden tests',
    () => runGoldenTests(
      [
        //TODO: fix those failing golden tests
        // generateDeviceBuilder(
        //   scenario: Scenario(name: 'valid username'),
        //   widget: loginPageFactory(
        //     username: Stubs.validEmail,
        //     password: Stubs.invalidPassword,
        //     showErrors: false,
        //     isLoading: false,
        //   ),
        // ),
        // generateDeviceBuilder(
        //   scenario: Scenario(name: 'invalid username'),
        //   widget: loginPageFactory(
        //     username: Stubs.invalidEmail,
        //     password: Stubs.invalidPassword,
        //     showErrors: true,
        //     isLoading: false,
        //   ),
        // ),
        // generateDeviceBuilder(
        //   scenario: Scenario(name: 'valid password'),
        //   widget: loginPageFactory(
        //     username: Stubs.invalidEmail,
        //     password: Stubs.validPassword,
        //     showErrors: false,
        //     isLoading: false,
        //   ),
        // ),
        // generateDeviceBuilder(
        //   scenario: Scenario(name: 'invalid password'),
        //   widget: loginPageFactory(
        //     username: Stubs.invalidEmail,
        //     password: Stubs.invalidPassword,
        //     showErrors: true,
        //     isLoading: false,
        //   ),
        // ),
        // generateDeviceBuilder(
        //   scenario: Scenario(name: 'valid data - no loading'),
        //   widget: loginPageFactory(
        //     username: Stubs.validEmail,
        //     password: Stubs.validPassword,
        //     showErrors: false,
        //     isLoading: false,
        //   ),
        // ),
        // generateDeviceBuilder(
        //   scenario: Scenario(name: 'valid data - loading'),
        //   widget: loginPageFactory(
        //     username: Stubs.validEmail,
        //     password: Stubs.validPassword,
        //     showErrors: false,
        //     isLoading: true,
        //   ),
        // ),
        generateDeviceBuilder(
          scenario: Scenario(name: 'error'),
          widget: loginPageFactory(error: 'Test errors'),
        ),
        generateDeviceBuilder(
          scenario: Scenario(name: 'loading'),
          widget: loginPageFactory(isLoading: true),
        ),
      ],
    ),
  );
}
