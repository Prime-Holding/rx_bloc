// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import '../configuration/config_params.dart';

abstract class BasePage {
  late PatrolIntegrationTester $;

  BasePage(this.$);

  Future<void> widgetVisibilityCheck(Key widget,
      [Duration timeout = ConfigParams.generalVisibleTimeout]) async {
    await $(widget).waitUntilVisible(timeout: timeout);
  }

  Future<void> pageVisibilityCheck(Key page) async {
    await widgetVisibilityCheck(page, ConfigParams.pageVisibleTimeout);
  }

  void isWidgetVisible(Key widget) {
    expect($(widget).visible, equals(true));
  }

  Future<bool> isVisible(PatrolFinder element) async {
    return $(element).visible ? true : false;
  }

  Future<bool> isDisplayed(PatrolFinder element) async {
    return element.evaluate().isNotEmpty ? true : false;
  }

  /// Here other base page methods will be added during test implementation process
}
