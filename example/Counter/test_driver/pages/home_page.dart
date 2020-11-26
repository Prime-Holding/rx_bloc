import 'package:flutter_driver/flutter_driver.dart';

class HomePage {
  final counterTxt = find.byValueKey('counter');
  static final incrementBtn = find.byValueKey('increment');
  static final decrementBtn = find.byValueKey('decrement');
  final reloadBtn = find.byValueKey('reload');
  static final reloadTxt = find.byValueKey('reload_text');
  static final snackBar = find.byType('SnackBar');

  FlutterDriver _driver;

  HomePage(FlutterDriver driver) {
    this._driver = driver;
  }

  Future<String> getCounterValue() async {
    return await _driver.getText(counterTxt);
  }

  Future<void> tapIncrementBtn() async {
      await _driver.tap(incrementBtn);
  }

  Future<void> tapDecrementBtn() async {
    await _driver.tap(decrementBtn);
  }

  Future<String> getSnackBarText() async {
    return await _driver.getText(snackBar);
  }

  Future<void> tapReloadBtn() async {
    return await _driver.tap(reloadBtn);
  }

  Future<String> getReloadedTxt() async {
    return await _driver.getText(reloadTxt);
  }
}
