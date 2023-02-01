# Rx Bloc CLI

Rx Bloc Command Line Interface helps you creating fully functional and feature-rich projects in just a moment. It comes with pre-generated features (such as flavors, app localization, etc) so you can start working on your project right away.

---

## Installing

```sh
$ dart pub global activate rx_bloc_cli
```

## Commands

### `$ rx_bloc_cli create`

![Create command][create_command_gif_lnk]

Create a new project at the given directory with lots of already set-up features out of the box. Customize your project with the following properties:

|  parameter |                 defaults to                 | description |
| ---------- |:-------------------------------------------:| :------------: |
|  `--project-name` | Name of directory where the project resides | The project name for this new Flutter project. This must be a valid dart package name. |
|  `--organisation` |                `com.example`                | The organisation name |
|  `--enable-analytics` |                   `false`                   | Enables Firebase analytics for the project |

### What's Included? 📦

Out of the box, a Rx Bloc CLI created projects includes:

✅ [Cross Platform Support][cross_platform_support_lnk] - Built-in support for Android, iOS and Web

✅ [Build Flavors][flutter_flavors_lnk] - Support for multiple flavors (development, staging and production)

✅ [Internationalization Support][localization_lnk] - Support multiple languages in your app just by adding translations and let the generator do the job for you

✅ [Sound Null-Safety][null_safety_lnk] - With sound null safety support, protect your app from null-dereference exceptions at runtime

✅ [rx_bloc][rx_bloc_lnk] - Integrated RxBlocs that help separate business logic from the presentation of the data in a clean, scalable and testable manner

✅ [Design system][design_system_lnk] - A single place where you can define all your colors, typography, assets and more. Your app's Light and Dark mode are already configured

✅ [Testing][testing_lnk] - With Unit and Golden Tests you know your app is working as intended

✅ [Static analysis][static_analysis_lnk] - Strict Lint rules which are used to write quality code

✅ [Analytics][firebase_analytics_lnk] - (Optional) Firebase analytics that keep track of how your app is used

✅ [Push notifications][push_notifications_lnk] - Receive push notifications and messages to your device using Firebase Cloud Messaging

✅ [Http client][dio_http_client_lnk] - Make API calls, download files, send form data and more using a built-in Http client

---

### `$ rx_bloc_cli --help`

See the complete list of commands and usage information.

```sh
Rx Bloc Command Line Interface

Usage: rx_bloc_cli <command> [arguments]

Global options:
-h, --help       Print this usage information.
-v, --version    Print the current version.

Available commands:
  create   Creates a new project in the specified directory.

Run "rx_bloc_cli help <command>" for more information about a command.
```

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