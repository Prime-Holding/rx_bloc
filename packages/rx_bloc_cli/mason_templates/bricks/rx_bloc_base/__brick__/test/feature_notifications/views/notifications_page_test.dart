import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import 'factories/notifications_page_factory.dart';

void main() {
  group(
    'NotificationsPage golden tests',
    () => runGoldenTests(
      [
        generateDeviceBuilder(
          scenario: Scenario(name: 'Permissions request - grated'),
          widget: notificationsPageFactory(permissionsAuthorized: true),
        ),
        generateDeviceBuilder(
          scenario: Scenario(name: 'Permissions request - declined'),
          widget: notificationsPageFactory(permissionsAuthorized: false),
        ),
        generateDeviceBuilder(
          scenario: Scenario(
              name: 'Show info card',
              onCreate: (key) async => {
                    //TODO: find a way to test IconButton (NotificationsPage#37)
                  }),
          widget: notificationsPageFactory(permissionsAuthorized: true),
        ),
      ],
    ),
  );
}
