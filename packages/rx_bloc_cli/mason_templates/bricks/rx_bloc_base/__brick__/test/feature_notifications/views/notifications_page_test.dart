{{> licence.dart }}

import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../../integration_test/main/configuration/build_app.dart';
import '../../helpers/golden_helper.dart';
import '../stubs.dart';
import 'factories/notifications_page_factory.dart';

void main() {
  group(
    'NotificationsPage golden tests',
    () => runGoldenTests(
      [
        buildScenario(
          scenario: 'success',
          widget: notificationsPageFactory(
            pushToken: Stubs.pushToken,
          ),
          customPumpBeforeTest: (tester) async => await tester.pump(
            const Duration(seconds: 5),
          ),
        ),
        buildScenario(
          scenario: 'error',
          widget: notificationsPageFactory(
            error: NotFoundErrorModel(message: 'Error message'),
          ),
        ),
        buildScenario(
          scenario: 'loading',
          widget: notificationsPageFactory(),
          customPumpBeforeTest: (tester) async => await tester.pump(
            const Duration(seconds: 5),
          ),
        ),
      ],
    ),
  );
}
