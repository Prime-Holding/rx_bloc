{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';

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
        ),
      ],
    ),
  );
}
