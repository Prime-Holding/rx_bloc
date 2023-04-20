import 'package:testapp/keys.dart';

import '../base/common.dart';
import 'base_page.dart';

class CounterPagePatrol extends BasePagePatrol {
  CounterPagePatrol(PatrolTester tester) : super(tester);

  final Finder locTxtCount = find.byKey(K.counterCount);
  final Finder locBtnIncrement = find.byKey(K.counterIncrement);
  final Finder locSpinnerIncrement = find.byKey(K.appLoadingIndicatorIncrement);
  final Finder locBtnDecrement = find.byKey(K.counterDecrement);
  final Finder locSpinnerDecrement = find.byKey(K.appLoadingIndicatorDecrement);
  final Finder locBtnReload = find.byKey(K.counterReload);
  final Finder locMdlError = find.byKey(K.counterError);
  final Finder locBtnError = find.byType(SmallButton);

  Future<void> tapBtnIncrement() async {
    await tapElement(locBtnIncrement, andSettle: false);
  }

  Future<void> tapBtnDecrement() async {
    await tapElement(locBtnDecrement, andSettle: false);
  }

  Future<void> tapBtnReload() async {
    await tapElement(locBtnReload);
  }

  Future<bool> isSpinnerIncrementDisplayed() async {
    return isVisible(locSpinnerIncrement);
  }

  Future<bool> isSpinnerDecrementDisplayed() async {
    return isVisible(locSpinnerDecrement);
  }

  Future<bool> isTextCountDisplayed() async {
    return isVisible(locTxtCount);
  }

  Future<bool> isModalErrorDisplayed() async {
    return isDisplayed(locMdlError);
  }

  Future<int> getCounterValue() async {
    return int.parse(tester(locTxtCount).text!);
  }

  Future<void> tapBtnError() async {
    await tapElement(locBtnError);
  }
}
