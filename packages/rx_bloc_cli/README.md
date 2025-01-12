# Rx Bloc CLI

Rx Bloc Command Line Interface helps you creating fully functional and feature-rich projects in just a moment. It comes with pre-generated features (such as flavors, app localization, etc) so you can start working on your project right away

---

## Installing

```sh
$ dart pub global activate rx_bloc_cli
```

## Commands

### `$ rx_bloc_cli create`

![Create command][create_command_gif_lnk]

## Features
<table>
  <tr>
    <td width="30%"><img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/docs/rx_bloc_cli_features/packages/rx_bloc_cli/doc/assets/SignUp.gif" alt="SignUp GIF">
</td>
    <td>
      <h3>Sign Up Flow</h3>
      <p>The onboarding flow begins with users creating an account by entering their email and password. After registration, users receive a confirmation email containing a deep link, which they must click to verify their email address. Next, users are prompted to confirm their phone number by entering an OTP (One-Time Password) sent via SMS. This two-step verification process ensures both email and phone number are authenticated for secure account access.</p>
      <p>Key functionalities:</p>
      <ul>
        <li>Initiate the flow by providing email and password.</li>
        <li>Provide and confirm an email through a deep link</li>
        <li>Provide and confirm an phone number through a OTP</li>
        <li>Resume the flow to the proper place if the app is restarted.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="30%"><img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/docs/rx_bloc_cli_features/packages/rx_bloc_cli/doc/assets/SignIn.gif" alt="SignUp GIF">
</td>
    <td>
      <h3>Authentication</h3>
      <p>Sign in to your account easily by using your email and password, or choose a social login option for quicker access. You can sign in with your Apple ID, Facebook, or Google account. If you’ve forgotten your password, simply reset it through the link provided. Choose the method that’s most convenient for you and get started right away</p>
      <p>Key functionalities:</p>
      <ul>
        <li>Authenticate via credentials (email and password).</li>
        <li>Social logins (Apple, Google, Facebook)</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="30%"><img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/docs/rx_bloc_cli_features/packages/rx_bloc_cli/doc/assets/Biometrics.gif" alt="Biometrics"></td>
    <td>
      <h3>Biometrics</h3>
      <p>A biometric authentication, providing users with secure and effortless access. This feature supports fingerprint and facial recognition for enhanced security.</p>
      <p>Key functionalities:</p>
      <ul>
        <li>Supports fingerprint and facial recognition for seamless login.</li>
        <li>Enhances app security with device-based biometric sensors.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="30%"><img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/docs/rx_bloc_cli_features/packages/rx_bloc_cli/doc/assets/CreatePIN.gif" alt="Biometrics"></td>
    <td>
      <h3>Create PIN Code</h3>
      <p>The PIN code allows the users to protect sensitive actions as well as providing application lock/unlock capabilities. This feature ensures encrypted local storage of PIN codes and seamless biometric authentication for enhanced user security.</p>
      <p>Key functionalities:</p>
      <ul>
        <li>Secure PIN Code Management: PIN codes are encrypted and stored in the device's secure storage.</li>
        <li>Automatic Biometric Login: Enables automatic biometric authentication on app restart when PIN is stored.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="30%"><img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/docs/rx_bloc_cli_features/packages/rx_bloc_cli/doc/assets/WidgetToolkit.gif" alt="Biometrics"></td>
    <td>
      <h3>Reusable Components (widget_toolkit)</h3>
      <p>The Widget Toolkit package offers a set of customizable UI components designed to boost productivity and reduce development time. These components provide flexible and efficient solutions for various common UI needs.</p>
      <p>Key functionalities:</p>
      <ul>
        <li>Item Picker (Multi-Select): Allows users to select multiple items from a list with ease.
</li>
        <li>Item Picker (Single Select): Enables single item selection for simplified user interaction.
</li>
        <li>Search Picker: Combines search functionality with item selection for an enhanced user experience.
</li>
        <li>Shimmer Effect: Displays placeholder loading animations to improve perceived loading times.
</li>
        <li>Launch URL: Facilitates easy linking and URL launching within the app.
</li>
        <li>Error Bottom Sheet: Provides a user-friendly interface for displaying error messages.
</li>
        <li>Text Field Dialog: Offers customizable dialogs with text input fields for various use cases.
</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="30%"><img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/docs/rx_bloc_cli_features/packages/rx_bloc_cli/doc/assets/ChangeLanguage.gif" alt="Biometrics"></td>
    <td>
      <h3>Localisation</h3>
      <p>Localization is vital for creating versatile, globally accessible apps with a personalized user experience.
</p>
      <p>Key functionalities:</p>
      <ul>
        <li>Seamless Integration in the widgets: Developers can easily integrate translations into the code.
</li>
        <li>Remote Localization Lookup: Supports fetching remote localizations during app start, allowing dynamic updates without requiring a new app release.
</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="30%"><img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/docs/rx_bloc_cli_features/packages/rx_bloc_cli/doc/assets/MFA.gif" alt="Biometrics"></td>
    <td>
      <h3>MFA (Multi-Factor Authentication)</h3>
      <p>The goal of Multi-Factor Authentication is to enable the business representative to configure the required authentication methods, such as PIN/Biometric, OTP, etc., for particular actions, such as unlock, change password, etc.
</p>
      <p>Key functionalities:</p>
      <ul>
        <li>PIN Code authentication.</li>
        <li>Biometric authentication.</li>
        <li>One Time Password (OTP)</li>
        <li>Other authentication methods can be easely integrated.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="30%"><img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/docs/rx_bloc_cli_features/packages/rx_bloc_cli/doc/assets/EnableNotifications.gif" alt="Biometrics"></td>
    <td>
      <h3>Notifications</h3>
      <p>Integrated Firebase Cloud Messaging (FCM) into the app starter to enable robust notification management, enhancing user engagement with timely updates and alerts.</p>
      <p>Key functionalities:</p>
      <ul>
        <li>Integrated Firebase Cloud Messaging (FCM): Set up and managed push notifications using Firebase.</li>
        <li>Notification Settings: Allowed users to enable, disable, their notification preferences.</li>
        <li>Automatic notifications unsibscribtion when the user logs out.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="30%"><img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/docs/rx_bloc_cli_features/packages/rx_bloc_cli/doc/assets/ScanQR.gif" alt="Biometrics"></td>
    <td>
      <h3>QR Scanner</h3>
      <p>Pre-built functionality that provides a QR scanner widget that was easily integrated into applications, enhancing functionality with efficient QR code scanning capabilities.</p>
      <p>Key functionalities:</p>
      <ul>
        <li>Customizable QR Scanner Widget: Offered the QrScannerWidget<T>, which displayed a QR scanner with a loading indicator, configurable to return expected values upon successful validation.</li>
          <li>Camera Permission Handling: Included functions like showAppCameraPermissionBottomSheet() to prompt users for camera access, facilitating seamless scanning experiences.</li>
          <li>Error Handling: Provided showQrScannerErrorBottomModalSheet() to display errors encountered during scanning, enhancing user feedback mechanisms.</li>
          <li>Integration with Validation Services: Allowed implementation of custom QrValidationService<T> to validate scanned QR codes as per application requirements.</li>
      </ul>
    </td>
  </tr>
</table>

Non-Interactive usage
```sh
$ rx_bloc_cli create <output_dir> <parameters> --no-interactive
```

Interactive usage
```sh
$ rx_bloc_cli create <output_dir> --interactive
```

Create a new project at the given directory with lots of already set-up features out of the box. Customize your project with the following properties:


| parameter                              |                 defaults to                 |                                                   description                                                   |
|----------------------------------------|:-------------------------------------------:|:---------------------------------------------------------------------------------------------------------------:|
| `--project-name`                       | Name of directory where the project resides |             The project name for this new Flutter project. This must be a valid dart package name.              |
| `--organisation`                       |                `com.example`                |                                              The organisation name                                              |
| `--[no-]enable-analytics`              |                   `false`                   |                           Enables Firebase Analytics and Crashlytics for the project                            |
| `--[no-]enable-feature-counter`        |                   `false`                   |                                     Enables Counter feature for the project                                     |
| `--[no-]enable-feature-deeplinks`      |                   `false`                   |                                Enables Deep Links showcase flow for the project                                 |
| `--[no-]enable-feature-widget-toolkit` |                   `false`                   |                         Enables widget_toolkit package showcase feature for the project                         |
| `--[no-]enable-feature-onboarding`     |                   `true`                    |                      Integrate Onboarding/Registration functionality into our application                       |
| `--[no-]enable-login`                  |                   `true`                    |                   Integrate login with email and password functionality into our application                    |
| `--[no-]enable-social-logins`          |                   `false`                   |            Integrate social login with Apple, Google and Facebook functionality into our application            |
| `--[no-]enable-change-language`        |                   `true`                    |                                Enables changing of the language for the project                                 |
| `--[no-]enable-remote-translations`    |                   `true`                    |                       Enables remote translation lookup for localizations for the project                       |
| `--[no-]enable-patrol`                 |                   `false`                   |                          Enables patrol package for integration tests for the project                           |
| `--[no-]realtime-communication`        |                   `none`                    |                      Enables realtime communication facilities for SSE. Values: none, sse.                      |
| `--[no-]enable-dev-menu`               |                   `true`                    |                           Enables dev menu to easily access proxy debugging services.                           |
| `--[no-]enable-otp`                    |                   `false`                   |                     Enables OTP feature that can help with building sms/pin code workflows.                     |
| `--[no-]enable-mfa`                    |                   `false`                   |                         Enables Multi-Factor Authentication capability for the project.                         |
| `--[no-]enable-profile`                |                   `true`                    |                                     Enables Profile feature for the project                                     |
| `--[no-]interactive`                   |                   `false`                   |              Enables interactive project generation flow flags are read from command line prompts               |
| `--[no-]enable-pin-code`               |                   `false`                   |            Enables pin code feature with biometrics, that can help with building pin code workflows.            |
| `--cicd`                               |                 `fastlane`                  | Provides a template for setting up ci/cd for your project. Available options: none, fastlane, github, codemagic |
| `--[no-]enable-feature-qr-scanner`     |                 `false`                     |                                   Enables QR scanner feature for the project                                    |

### `$ rx_bloc_cli create_distribution`

Usage:

```sh
rx_bloc_cli create_distribution <output_dir>
```

Creates a new distribution project for all your deployment and testing credentials, provisioning profiles, certificates, etc.


### `$ rx_bloc_cli --help`

See the complete list of commands and usage information.

```sh
Rx Bloc Command Line Interface

Usage: rx_bloc_cli <command> [arguments]

Global options:
-h, --help       Print this usage information.
-v, --version    Print the current version.

Available commands:
  create				Creates a new project in the specified directory.
  create_distribution	Creates a new distribution project in the specified directory.

Run "rx_bloc_cli help <command>" for more information about a command.
```

## What's Included? 📦

Out of the box, a Rx Bloc CLI created projects includes:

✅ [Cross Platform Support][cross_platform_support_lnk] - Built-in support for Android, iOS and Web

✅ [Build Flavors][flutter_flavors_lnk] - Support for multiple flavors (development, staging and production)

✅ [Internationalization Support][localization_lnk] - Support multiple languages in your app just by adding translations and let the generator do the job for you

✅ [Sound Null-Safety][null_safety_lnk] - With sound null safety support, protect your app from null-dereference exceptions at runtime

✅ [rx_bloc][rx_bloc_lnk] - Integrated RxBlocs that help separate business logic from the presentation of the data in a clean, scalable and testable manner

✅ [Design system][design_system_lnk] - A single place where you can define all your colors, typography, assets and more. Your app's Light and Dark mode are already configured

✅ [Testing][testing_lnk] - With Unit and Golden Tests you know your app is working as intended.

✅ [Static analysis][static_analysis_lnk] - Strict Lint rules which are used to write quality code

✅ [Analytics][firebase_analytics_lnk] - (Optional) Firebase analytics that keep track of how your app is used

✅ [Push notifications][push_notifications_lnk] - Receive push notifications and messages to your device using Firebase Cloud Messaging

✅ [Http client][dio_http_client_lnk] - Make API calls, download files, send form data and more using a built-in Http client

---

## Extendability

Rx Bloc Command Line Interface supports [extendability] with the help of mason templates


[null_safety_lnk]: https://dart.dev/null-safety
[localization_lnk]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[cross_platform_support_lnk]: https://flutter.dev/docs/development/tools/sdk/release-notes/supported-platforms
[flutter_flavors_lnk]: https://flutter.dev/docs/deployment/flavors
[rx_bloc_lnk]: https://pub.dev/packages/rx_bloc
[design_system_lnk]: https://uxdesign.cc/everything-you-need-to-know-about-design-systems-54b109851969
[testing_lnk]: https://flutter.dev/docs/testing
[static_analysis_lnk]: https://dart.dev/guides/language/analysis-options
[firebase_analytics_lnk]: https://pub.dev/packages/firebase_analytics
[push_notifications_lnk]: https://firebase.google.com/products/cloud-messaging/
[create_command_gif_lnk]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_cli/doc/assets/rx_bloc_cli_create.gif
[dio_http_client_lnk]: https://pub.dev/packages/dio
[interceptors_lnk]: https://pub.dev/documentation/dio/latest/dio/Interceptor-class.html
[extendability]: /packages/rx_bloc_cli/mason_templates/README.md








