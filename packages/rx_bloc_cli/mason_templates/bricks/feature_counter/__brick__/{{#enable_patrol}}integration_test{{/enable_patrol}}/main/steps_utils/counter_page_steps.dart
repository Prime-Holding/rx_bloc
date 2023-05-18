{{> licence.dart }}

import '../configuration/build_app.dart';
import '../pages/counter_page.dart';

class CounterPageSteps {
  static Future<void> incrementAction(PatrolTester $) async {
    CounterPage counterPage = CounterPage($);
    await $.pumpAndSettle();
    for (int i = 1; i <= 5; i++) {
      await counterPage.tapBtnIncrement();
      expect(await counterPage.isSpinnerIncrementDisplayed(), equals(true));
      await $.pumpAndSettle();
      expect(await counterPage.getCounterValue(), equals(i));
    }
  }

  static Future<void> decrementAction(PatrolTester $) async {
    CounterPage counterPage = CounterPage($);
    await $.pumpAndSettle();
    for (int i = 5; i > 0; i--) {
      await counterPage.tapBtnDecrement();
      expect(await counterPage.isSpinnerDecrementDisplayed(), equals(true));
      expect(await counterPage.getCounterValue(), equals(i));
    }
  }

  static Future<void> showErrorModalSheetIncrement(PatrolTester $) async {
    CounterPage counterPage = CounterPage($);
    await counterPage.tapBtnIncrement();
    await $.pumpAndSettle();
    expect(await counterPage.isModalErrorDisplayed(), true);
    await $.pumpAndSettle();
    await counterPage.tapBtnError();
  }

  static Future<void> showErrorModalSheetDecrement(PatrolTester $) async {
    CounterPage counterPage = CounterPage($);
    await counterPage.tapBtnDecrement();
    await $.pumpAndSettle();
    expect(await counterPage.isModalErrorDisplayed(), true);
    await $.pumpAndSettle();
    await counterPage.tapBtnError();
  }

  static Future<void> reloadCounter(PatrolTester $) async {
    CounterPage counterPage = CounterPage($);
    await counterPage.tapBtnReload();
    expect(await counterPage.isTextCountDisplayed(), true);
  }
}
