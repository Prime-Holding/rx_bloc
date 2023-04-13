
import 'package:flutter/foundation.dart';
import 'package:testapp/keys.dart';

import '../common.dart';

class CounterHelper {
  CounterHelper(this.$);
  final PatrolTester $;

  Future<void> tapActionButton(
    Finder element,
    Key buttonKey,
    Key loadingIndicatorKey,
    int counterValue,
  ) async {
    await $.waitUntilVisible(element);
    await $(buttonKey).tap(andSettle: false);
    expect($(loadingIndicatorKey).visible, equals(true));
    await $.pumpAndSettle();
    expect(int.parse($(K.counterCountKey).text!), equals(counterValue));
  }

  Future<void> showErrorModalSheet(Key buttonKey) async {
    await $(buttonKey).tap();
    await $.pumpAndSettle();
    expect($(K.counterErrorKey).evaluate().isNotEmpty ? true : false, true);
    await $.pumpAndSettle();
    await $(find.byType(SmallButton)).waitUntilVisible().tap();
  }
}
