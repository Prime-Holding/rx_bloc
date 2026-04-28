// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:testapp/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../stubs.dart';
import 'factories/notifications_page_factory.dart';

void main() {
  group(
    'NotificationsPage golden tests',
    () => runGoldenTests([
      buildScenario(
        scenario: 'success',
        widget: notificationsPageFactory(pushToken: Stubs.pushToken),
      ),
      buildScenario(
        scenario: 'error',
        widget: notificationsPageFactory(
          error: NotFoundErrorModel(message: 'Error message'),
        ),
      ),
      buildScenario(scenario: 'loading', widget: notificationsPageFactory()),
    ]),
  );
}
