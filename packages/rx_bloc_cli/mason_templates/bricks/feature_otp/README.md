# feature_otp

The `feature_otp` brick contains a number of useful widgets that can help you with building sms/pin code screens or workflows for your app. The brick contains widgets for entering pin codes, pasting them, resend logic and more.

## Widgets

The `feature_otp` brick consists of the following widgets:

### SmsCodeField

`SmsCodeField` is a wrapper around package [Pinput](https://pub.dev/packages/pinput) and exposes all its customization options. In addition it provides default implementations for some of the brick properties and styles it in `themeData`. Supports auto fill and paste. By default it uses the inter feature communication, implemented with the `SmsCodeBloc`. To use it as stand alone widget, set its property `useInternalCommunication` to false.

### CountdownWidget

`CountdownWidget` is used to keep track of the remaining time.

An `onCountdownTick` callback can be provided to keep track of any changes happening. This callback accepts the remaining countdown time to which the user of the widget can react. This callback is triggered after the frame has been rendered in order to prevent any potential `setStates` happening and modifying the widget during its build phase.

You can also access the remaining time, as well as the elapsed time of the countdown via a controller.  The controller also gives you the possibility to reset the countdown and start it from a custom time (provided in seconds).

By default, every countdown is presented in the format of remaining seconds, however, you can change this to include minutes and hours by changing the `timeFormat` parameter of the widget.

By default, the highest number (minutes in the minutes format, hours in the hours format) will be displayed with double digits (even if a single digit number is presented). In case you want to disable this behavior, you can set the `preferDoubleDigitsForTime` parameter to `false`.

### AutomatedResendCodeButton

`AutomatedResendCodeButton` maintains its own state. Once the button gets pressed, it goes through a few statuses (`loading`, `codeSent`, `disabled`, `active`, `error`). The button is enabled only in the `active` state.  
There are a lot of options to be customized such as providing `icons`, `labels`, `colorStyles`, `textStyles` etc. To prevent the user from spam pressing the button it gets disabled for long after the `onPressed` callback is executed.  
This ensures we provide the user with only one code at a time. Uses the `CountdownWidget` under the hood.

### ResendCodeButton

`ResendCodeButton` might be maintained from your business logic, but by default it uses `SmsCodeBloc`. It builds a `TextButton` with great amount of customization options and automated styling.

### SmsPhoneNumberField

`SmsPhoneNumberField` is a kind of builder which provides a phone number and a callback to update the saved phone number. It is handy for building (if needed) a sms phone number field, wrapped in a `SmsCodeWidget`.

### ResendButtonTimer

`ResendButtonTimer` wraps `CountdownWidget` with the business logic provided from `SmsCodeBloc`. It has a builder, which allows you to build a custom widget in place of the `CountdownWidget`, using the same business logic.

### ValidityWidget

`ValidityWidget` displays how long a current code is valid to the user to use it. After that time user can request new code and reset timer.  
This widget can not be used outside the `SmsCodeBloc` and its content might be fully recreated using its builder.

### SmsCodeProvider

`SmsCodeProvider` is a user friendly way to provide all dependencies for the implemented business logic and, in the same step, arrange the page content depending on the bloc's states and events.

## How To Use

There are two ways of using this brick - to use prebuilt widgets to visualize your own business logic, or to use the provided `SmsCodeBloc` and arrange widgets in a page however you want.

You can use the following widgets without `SmsCodeBloc`:

- `CountdownWidget`
- `AutomatedResendCodeButton`
- `SmsCodeField(set useInternalCommunication = false)`
- `ResendCodeButton(set useInternalCommunication = false)`

To use the implemented business logic, you first need to provide in the context `SmsCodeBloc` and an implementation of `SmsCodeService`. Then, to render your page content, you can use `SmsPhoneNumberField`  (combine it with custom widget or with `TextFieldDialog`), `ValidityWidget`, `ResendCodeButton`, `ResendButtonTimer` and `SmsCodeField`. Use `SmsCodeProvider` to have all dependencies provided and use its builder to easily create your page content.

### An example of how to achieve the integrated `SmsCodeProvider` functionality:

Step 1. Create an implementation of `SmsCodeService`:
```dart
class MyCustomSmsCodeService implements SmsCodeService {  
  @override  
  Future<dynamic> confirmPhoneCode(String code) async {  
    //send a request to the server to verify the code and return the response...  
  }  
  
  @override  
  Future<String> getFullPhoneNumber() async {  
    //fetch user's phone number...  
  }  
  
  @override  
  Future<String> updatePhoneNumber(String newNumber) async {  
    //update the user's number and return new one...  
  }  
  
  @override  
  Future<bool> sendConfirmationSms(String usersPhoneNumber) async {  
    //resend SMS code  
  }  
  
  @override  
  Future<int> getValidityTime(bool reset) async {  
    //how long the sent code will be valid...  
  }  
  
  @override  
  Future<int> getResendButtonThrottleTime(bool reset) async {  
    //time until next resend is available in seconds...  
  }  
  
  @override  
  Future<int> getCodeLength() async {  
    //fetch code length...  
  }  
}
```

Step 2. Assemble `SmsCodeProvider` and its subsequent widgets:
```dart
SmsCodeProvider(  
  sentNewCodeActivationTime: 2,  
  smsCodeService: MyCustomSmsCodeService(),  
  builder: (state) => Column(  
    children: [  
      SmsPhoneNumberField(  
        builder: (context, number, onChanged) => TextFieldDialog(  
            value: number,  
            onChanged: onChanged,  
            ...  
        ),  
      ),  
      const SmsCodeField(),  
      const ValidityWidget(),  
      const ResendCodeButton(),  
      const ResendButtonTimer(),  
    ],  
  ),  
),
```
