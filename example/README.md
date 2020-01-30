# Example Usage - RxBlocListener

```dart
RxBlocListener<CounterBlocType, String>( // Specify the type of the bloc and its state
    state: (bloc) => bloc.states.infoMessage, // pick a specific state you want to listen for
    listener: (context, state) => 
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(state))) // Listen for the state you have specified above
)
```

# Example user - RxBlocBuilder

```dart
RxBlocBuilder<CounterBlocType, bool>( // Specify the type of the bloc and its state
    state: (bloc) => bloc.states.decrementEnabled, // pick a specific state you want to listen
    builder: (context, snapshot, bloc) => RaisedButton(
        child: Text('Do some action'),
        onPressed: (snapshot.data ?? false) ? bloc.events.decrement : null,
   ),
)
```
# UI Integration tests using Flutter Driver
Integration tests work as a pair: first, deploy an instrumented application to a real device or emulator and then “drive” the application from a separate test suite, checking to make sure everything is correct along the way.

To create this test pair, use the flutter_driver package. It provides tools to create instrumented apps and drive those apps from a test suite

## Page Object Model
A page object is an object-oriented class that serves as an interface to a page of your AUT. Page object class contains locators for the app elements and methods for manipulation of those elements. (**home_page.dart**)
### Element Localization (SerializableFinders) 
Posible locators in flutter driver:
- ```find.bySemanticsLabel```
- ```find.byToolTip```
- ```find.byType```
- ```find.byValueKey``` (most used)

Examples:
```
final counterTxt = find.byValueKey('counter');
static final incrementBtn = find.byValueKey('increment');
static final decrementBtn = find.byValueKey('decrement');
final reloadBtn = find.byValueKey('reload');
static final reloadTxt = find.byValueKey('reload_text');
static final snackBar = find.byType('SnackBar');
```
### Driver Methods (element manipulation)
Flutter driver provides methods for manipulating elements. (tap, getText)

Examples:
```
  Future<void> tapIncrementBtn() async {
      await _driver.tap(incrementBtn);
  }
  Future<void> tapDecrementBtn() async {
    await _driver.tap(decrementBtn);
  }
  Future<String> getSnackBarText() async {
    return await _driver.getText(snackBar);
  }
  ```
 For further information on Flutter Driver methods check:
[Flutter_Driver_Library](https://api.flutter.dev/flutter/flutter_driver/flutter_driver-library.html "Flutter Driver Library")

## Setup
1.Add the flutter_driver dependency
```
dev_dependencies:
  flutter_driver:
    sdk: flutter
  test: any
```
2.Create the test files
This creates the following directory structure:
```
example/
  lib/
    main.dart
  test_driver/
    e2e.dart
    e2e_test.dart
```
3.Instrument the app
Add this code inside the test_driver/e2e.dart file:

```
import 'package:flutter_driver/driver_extension.dart';
import 'package:counter_app/main.dart' as app;

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  app.main();
}
```
4.Write the tests
In e2e_test.dart you can write the integration tests.

```
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
```
5.Run the tests
In order to run the test you need to have a running emulator or connected physical device. If these preconditions are met, just write this command in the terminal:
```
flutter drive --target=test_driver/e2e.dart
```

For more information check:
[UI_Integration](https://flutter.dev/docs/cookbook/testing/integration/introduction "UI_Integration")

## Additional implementations:
- Common constands can be found in **app_constants.dart**. This file contains common messages or predifined waits.
```
  static const String MIN_DECREMENT_COUNT_MSG = "You have reached the minimum decrement count";
  static const Duration ONE_SECOND = Duration(seconds: 1);
```
- Common methods used to ease testing can be found in **common_functionalities.dart**.
```
  //Performs multiple clicks
  static Future<void> multipleTaps(
      SerializableFinder finder, FlutterDriver driver, int increments) async {
    for (var i = 0; i <= increments; i++) {
      await driver.tap(finder);
    }
  }
```
