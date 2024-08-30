# PATROL INTEGRATION TEST

## Introduction

Unit tests and widget tests are handy for testing individual classes, functions, or widgets.  
However, they generally don’t test how individual pieces work together as a whole,  
or capture the performance of an application running on a real device.  
These tasks are performed with e2e integration tests.

Integration tests are written using the **integration_test** package, provided by the SDK and enhanced with Patrol testing framework for Flutter.

## Tech Stack

- Dart
- Flutter
- Patrol
- Android Studio
- Xcode

## High level architecture

![Patrol 1 user interface testing][patrol_architecture_img]

## Setup

- Check the official [Windows][flutter_get_started_windows] installation guide.

- Check the official [MacOS][flutter_get_started_macos] installation guide.

- Check the official [Set up an editor][flutter_get_started_editor] guide.

- Check the official [Patrol][patrol_get_started] installation guide.


### Install patrol_cli

1. Install patrol executable:  
   `dart pub global activate patrol_cli`

2. Verify that installation was successful:  
   `patrol --version`


## Native automation setup:

Check the official [Getting Started]([leancodepl/patrol](https://patrol.leancode.co/getting-started)) guide for **Android** and **iOS**.

## Project Structure

```markdown
── integration_test  
│   ├── integration_tests_framework  
│   │   ├── base  
│   │   ├── configuration  
│   │   ├── page_objects  
│   │   ├── steps_utils  
│   ├── tests  
│   │   ├── login_tests  
│   │   ├── transfer_tests  
├── lib  
│   ├── keys_testing  
|   |   ├── keys.dart  
```

`integration_test`: Is the main mobile e2e test package.

`integration_tests_framework`: Contains all base functions, configuration methods, page objects, and step utilities.

`base`: it includes the base page where PatrolTester is defined, along with all the generic methods inherited by all page classes, as well as all utility methods.

`configuration`: It consists of classes and methods that facilitate the construction of the app on various environments and establish the foundational configuration for Patrol.

`page-objects`:This is where all page classes and their respective methods are defined.

`step-utils`: This is where all step classes and their associated methods, which are specific to particular pages, are defined.

`test`: All tests are placed here.

`keys.dart` Keys for locating elements can be found in this file.

## Naming Conventions

*Effective Dart* guides can be found here [Guides][effective_dart].

**Finders** starts with **Name** followed by **Type**:

| Finder type | Example |
| --- | --- |
| TextField | emailTextField, nameTextField |
| Button | submitButton, confirmButton |

**POM methods** start with **Action** followed by **Name** and **Type**:

| Gesture | Action | Type | Example |
| --- | --- | --- | --- |
| Tap | tap | Button | tapConfirmButton |
| Enter Text | set | TextField | setEmailTextField |

**Keys** start with **Page** followed by **Name** and **Type**:

| Page | Type | Example |
| --- | --- | --- |
| personalInfo | Button | personalInfoEmailSubmitButton |
| personalInfo | TextField | personalInfoEmailTextField |

## Locator Strategy

**PREFER** using **keys** to find widgets.Patrol's custom finders are very powerful, but we are quite confident that keys are the best way to find widgets.

```dart
Future<void> tapEmailButton() async {  
    await $(Keys.personalInfoAddEmailButton).tap();  
}  
```

If the type of elements is only one on the page, we can localize it with class.  
For example check `base_page.dart` class:

```dart
final Type _closeButtonType = AppSmallButton;  

Future<void> tapClose() async {  
    await $(_closeButtonType).tap();  
}  
```

**Texts can be used as last resort on localization edge cases.**

All **keys** are stored in file `keys.dart`.

```markdown
|── lib  
│   ├── keys_testing  
│   │   ├── keys.dart  
```

For additional info check: [Effective Patrol][effective_patrol]

### Handling Keys

**Keys** are not defined during implementation. This requires a key to be added for testing purposes. Some times its tricky to find the right element, but with help from a developer it can be handled.

**Prerequisites:**

1. App is running

2. Page under test is loaded

3. **Flutter Inspector** is opened


**Steps:**

1. Find the element under test by using Flutter Inspector

2. Define a **Key** for the element under test

3. Copy the **Key** value, it should be a String

4. Create a **Key** variable in the Keys class

5. Use the **Key** constant in POM class to interact with element


## POM

Page object classes contain all locators of element and atomic action methods for them.

Simple locators that are used only once can be set as parameter directly in the method.

```dart
Future<void> tapConfirmButton() async {  
    await $(Keys.ConfirmButton).tap(andSettle:false);
}  
```

In case where we have complex locators or locator is used in multiple methods we can declare them as variables.

```dart
PatrolFinder get confirmButton => $(Keys.confirmButton);  

Future<void> tapSelfTransferButton() async {  
    await confirmButton.tap(andSettle:false);
}  
```

Create **steps_utils** classes classes that contain methods of **steps** which are used to shorten the tests.

```dart
class PersonalInfoObjPageSteps {
  
  static Future<void> setEmailAddress(
      PatrolIntegrationTester $, String emailAddress) async {
    final personalInfoObjPage = PersonalInfoObjPage($);
    await personalInfoObjPage.tapAddEmailAddressButton();
    await personalInfoObjPage.setEmailAddress(emailAddress);
    await personalInfoObjPage.tapEmailSaveButton();
  }

  static Future<void> setId(PatrolIntegrationTester $, String id) async {
    final personalInfoObjPage = PersonalInfoObjPage($);
    await personalInfoObjPage.tapAddIdButton();
    await personalInfoObjPage.setId(id);
    await personalInfoObjPage.tapIdSaveButton();
  }
}
```

## Creating tests

- Try to introduce as little conditional logic as possible to help keep the main path straight. In practice, this usually comes down to having as few `if`s as possible.

- Keeping your test code simple and to the point will also help you in debugging it.

- **DO** add a good test description explaining the test's purpose

- `testFLO` Test case

- Variables section and so on

- Create **one** test file per **e2e** scenario


```dart
//Variables
final testDataFile =
    unsuccessful_onboarding_already_existing_client_test_datajson;

final emailAddress = Utils.getTestData(testDataFile, 'emailAddress');
final id = Utils.getTestData(testDataFile, 'id');

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  ///Test Case
  ///Onboarding - Unsuccessful onboarding of new client - client already exist
  ///This test will check if already existing client is unable to complete the onboarding and register as a new client.
  ///https://jira.primeholding.bg:8443/browse/MA-6739
  patrolBaseConfig.patrol(
      'Onboarding - Unsuccessful onboarding of new client - client already exist',
      ($) async {

    final onboardObjPage = OnboardObjPage($);
    final personalInfoObjPage = PersonalInfoObjPage($);


    await BuildApp($).buildApp();

    await onboardObjPage.tapOnboardButton();
    await onboardObjPage.tapConfrimButton();

    //This section can be wrapped in a single steps method
    await PersonalInfoObjPageSteps.setEmailAddress($, emailAddress);
    await PersonalInfoObjPageSteps.setId($, id);
    await personalInfoObjPage.tapServicesCheckBox();
    await personalInfoObjPage.tapMarketingCheckBox();
    await personalInfoObjPage.tapPersonalDataCheckBox();
    await personalInfoObjPage.tapConfirmButton();

    await InstructionsObjPage($).checkQrCodeButtonVisibility();
  });
}
```

## Running tests

`patrol test --target <test_file_to_run> --flavor <env> --device <device_id> --no-uninstall --release (IoS) / --debug (Android) --no-label (required)`

This command does the following things:

1. Build the app under test and the instrumentation app
2. Install the instrumentation on the selected device
3. `--target` defines which tests to be run. (not specifying target will run all tests)
4. `--flavor` defines on which env of the app to run the tests
5. `--device` defines on which device to run the tests on
6. `--no-uninstall` will not uninstall the app after running tests
7. `--release` used only when running tests on IoS
8. `--debug` used when running tests on Android
9. `--no-label` (required) hides a label bar with the test file name

**Examples**:  
**IOS**  
`patrol test --target integration_test/tests --flavor dev --device <device_id> --no-uninstall --release --no-label`

**Android**  
`patrol test --target integration_test/test --flavor dev --device <device_id> --no-uninstall --debug --no-label`

To see all available options and flags, run `patrol test --help`.

Additional info can be found here [Commands - test][patrol_cli_commands].

## Reporting

### Android

- Standard Patrol reporting

After each test run a report from Patrol can be found under: 
```
{project_root}}/build/app/reports/androidTests/connected/flavors/{flavor}
```

---

[patrol_architecture_img]: https://leancode.co/_next/image?url=https%3A%2F%2Fimages.prismic.io%2Fleancodelanding2%2Fe2f278bc-a2c0-473e-95d5-21631a7e7d16_arch2.jpg%3Fauto%3Dcompress%2Cformat&w=3840&q=70
[flutter_get_started_windows]: https://docs.flutter.dev/get-started/install/windows
[flutter_get_started_macos]: https://docs.flutter.dev/get-started/install/macos
[flutter_get_started_editor]: https://docs.flutter.dev/get-started/editor
[patrol_get_started]: https://patrol.leancode.co/getting-started
[effective_dart]: https://dart.dev/guides/language/effective-dart
[effective_patrol]: https://patrol.leancode.co/effective-patrol#prefer-using-keys-to-find-widgets
[patrol_cli_commands]: https://patrol.leancode.co/cli-commands/test