# UI Integration tests using Flutter Driver
## Page Object Model
A page object is an object-oriented class that serves as an interface to a page of your AUT. Page object class contains locators for the app elements and methods for manipulation of those elements. (**home_page.dart**)
### Element Localization (SerializableFinders) 
Possible locators in flutter driver:
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
 For further information on Flutter Driver methods check: [Flutter Driver Library](https://api.flutter.dev/flutter/flutter_driver/flutter_driver-library.html "Flutter Driver Library")

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

For more information check: [UI Integration](https://flutter.dev/docs/cookbook/testing/integration/introduction "UI_Integration")

## Additional implementations:
- Common constands can be found in **app_constants.dart**. This file contains common messages or predifined waits.
```
  static const String MIN_DECREMENT_COUNT_MSG = "You have reached the minimum decrement count";
  static const Duration ONE_SECOND = Duration(seconds: 1);
```
- Common methods used to ease testing can be found in **common_functionalities.dart**.
```
  //Performs multiple taps
  static Future<void> multipleTaps(
      SerializableFinder finder, FlutterDriver driver, int increments) async {
    for (var i = 0; i <= increments; i++) {
      await driver.tap(finder);
    }
  }
```

## BDD - Gherkin
Gherkin is a language, which is used to write Features, Scenarios, and Steps. The purpose of Gherkin is to help us write concrete requirements.

### Setup
Add **flutter_gherkin** to dependencies and click **"Packages get"**
```
dev_dependencies:
  flutter_test:
    sdk: flutter
  test: any
  flutter_driver:
    sdk: flutter
  flutter_gherkin: ^1.1.7+3
  build_runner:
  rx_bloc_generator: ^0.0.1
```
### Directory Structure 
Create the following directory structure:
```
example/
	test_driver/
  		feature/
    		add_substract.feature (Cucumber)
  		steps/
  			decrement_counter.dart
			increment_counter.dart
	bdd.dart
	bdd_test.dart
```
###Feature files
Feature files contain the test scenarios described using Gherkin language.
```
  Scenario: Test Decrement feature of the app
    Given I test the initial state of the app with value as 0
    And I click the Increment button
    And I click the Increment button
    And I click the Decrement button
    Then I see if the values is 1
```
For more information check: [BDD Gherkin](https://www.tutorialspoint.com/behavior_driven_development/behavior_driven_development_gherkin.htm "BDD - Gherkin")

### Step files
For every step described in the feature files there must be a representing step file containing the code that performs that action.
```
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import '../pages/home_page.dart';

class DecrementCounter extends ThenWithWorld<FlutterWorld> {
  DecrementCounter()
      : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  Future<void> executeStep() async {
    HomePage homePage = HomePage(world.driver);

    await homePage.tapDecrementBtn();
  }

  @override
  RegExp get pattern => RegExp(r"I click the Decrement button");
}
```
###bdd.dart
This file executes the application and enables the flutter driver.
```
import 'package:flutter_driver/driver_extension.dart';
import 'package:example/main.dart' as app;

void main() {
  enableFlutterDriverExtension();
  app.main();
}
```
### bdd_test.dart
This file contains the step definition and additional settings to run the tests.
```
import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'steps/decrement_counter.dart';
import 'steps/increment_counter.dart';
import 'steps/initial_counter_value.dart';
import 'steps/new_counter_value.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..stepDefinitions = [InitialCounterValue(), IncrementCounter(), CounterNewState(), DecrementCounter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/bdd.dart"
  // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}
```
For more information check: 
- [Tutorial 1](https://www.youtube.com/watch?v=1qoWnS1hjhY&list=PL6tu16kXT9PrzZbUTUscEYOHHTVEKPLha&index=8 "Tutorial 1")
- [Tutorial 2](https://www.youtube.com/watch?v=aj4YjLtcudA&list=PL6tu16kXT9PrzZbUTUscEYOHHTVEKPLha&index=10&t=0s "Tutorial 2")
- [Tutorial 3](https://www.youtube.com/watch?v=4l65xoJUVLA&list=PL6tu16kXT9PrzZbUTUscEYOHHTVEKPLha&index=10 "Tutorial 3")

### Running BDD tests
In order to run the test you need to have a running emulator or connected physical device. If these preconditions are met, just write this command in the terminal:
```
flutter drive --target=test_driver/bdd.dart
```