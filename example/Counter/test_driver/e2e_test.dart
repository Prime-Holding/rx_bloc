import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'common/app_constants.dart';
import 'common/common_functionalities.dart';
import 'pages/home_page.dart';

void main() {
  group('Home Screen Test', () {
    FlutterDriver driver;
    setUpAll(() async {
// Connects to the app
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if (driver != null) {
// Closes the connection
        driver.close();
      }
    });

    test('verify counter initial value', () async {
      expect(await HomePage(driver).getCounterValue(), '0');
    });

    test('verify maximum incrementation count message', () async {
      await CommonFunctionalities.multipleTaps(
          HomePage.incrementBtn, driver, 5);

      await driver.waitFor(HomePage.snackBar, timeout: AppConstants.ONE_SECOND);

      await driver.waitFor(find.text(AppConstants.MAX_INCREMENT_COUNT_MSG));

      await HomePage(driver).tapIncrementBtn();

      expect(await HomePage(driver).getCounterValue(), "5");
    });

    test('verify minimum decrement count message', () async {
      await CommonFunctionalities.multipleTaps(
          HomePage.decrementBtn, driver, 5);

      await driver.waitFor(HomePage.snackBar,
          timeout: AppConstants.THREE_SECONDS);

      await driver.waitFor(find.text(AppConstants.MIN_DECREMENT_COUNT_MSG));

      await HomePage(driver).tapDecrementBtn();
      expect(await HomePage(driver).getCounterValue(), "0");
    });

    test('verify that tap on reload button, changes the initial text',
        () async {
      var initialTxt = await (HomePage(driver).getReloadedTxt());

      await HomePage(driver).tapReloadBtn();

      await CommonFunctionalities.waitForTextToChange(
          HomePage.reloadTxt, driver);

      expect(await HomePage(driver).getReloadedTxt(), isNot(initialTxt));
    });
  });
}
