# Test App

## Getting started

Before you start working on your app, make sure you familiarize yourself with the structure of the generated project and the essentials that are included with it.

*Note:* The app contains features that request data from API endpoints hosted on a local server. For the app to function properly, make sure the local server is up and running. For more info, check out the [server topic](#server).

## Project structure

| Path | Contains |
| ------------ | ------------ |
| `lib/base/` | Common code used on more than one **feature** in the project. |
| `lib/base/app/` | The root of the application and Environment configuration. |
| `lib/base/common_blocs/` | Global [BLoCs][rx_bloc_info_lnk]|
| `lib/base/common_ui_components/` | Reusable widgets (buttons, controls etc) |
| `lib/base/common_use_cases/` | Global UseCases |
| `lib/base/data_sources/` | All data sources are placed here. |
| `lib/base/data_sources/domain/` | Data sources,  relating to a specific domain |
| `lib/base/data_sources/domain/counter/` | Data sources,  relating to the counter domain |
| `lib/base/data_sources/local/` | Local data sources, such as shared preferences, secured storage etc. |
| `lib/base/data_sources/remote/` | External data sources like APIs. Here is placed all [retrofit][retrofit_lnk] code. |
| `lib/base/data_sources/remote/interceptors/` | Custom interceptors that can monitor, rewrite, and retry calls. |
| `lib/base/di/` | Global dependencies, available in the whole app|
| `lib/base/extensions/` | Global [extension methods][extension_methods_lnk] |
| `lib/base/models/` | Data models used in the project |
| `lib/base/repositories/` | Repositories used to fetch and persist models. |
| `lib/base/routers/` | All [routers][autoroute_usage_lnk] are placed here. The main [router][autoroute_usage_lnk] of the app is `lib/base/routers/router.dart`. |
| `lib/base/routers/guards/` | The routers' [guards][autoroute_usage_lnk] of the app are placed here. |
| `lib/base/theme/` | The custom theme of the app |
| `lib/base/utils/` | Global utils |
| `lib/feature_X/` | Feature related classes |
| `lib/feature_X/blocs` | Feature related [BLoCs][rx_bloc_info_lnk] |
| `lib/feature_X/di` | Feature related dependencies |
| `lib/feature_X/use_cases/` | Feature related UseCases |
| `lib/feature_X/ui_components/` | Feature related custom widgets |
| `lib/feature_X/views/` | Feature related pages and forms |
| `lib/main.dart` | The main file of the app. If there are more that one main file, each of them is related to separate flavor of the app. |

## Feature structure

Each feature represents a separate flow in the app. They can be composed of one or more pages (screens) placed inside the features `views` directory. **Every page (screen) should be implemented as a Stateless Widget.**

The logic of each page should be placed into its own [BLoC][rx_bloc_lnk]. This is desired especially if the page has to be a **Stateful Widget**. The BLoC is placed inside the `blocs` directory. In order for the BLoC to be more readable, its implementation details can be offloaded to its own extensions file ( `[bloc_name]_extensions.dart`, placed inside the same directory) or one or more usecases.

## Architecture
<img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_cli/mason_templates/bricks/rx_bloc_base/__brick__/docs/app_architecture.jpg" alt="Rx Bloc Architecture"></img>

<div id="navigation"/>

### Navigation

Navigation throughout the app is handled by [Auto Route][autoroute_lnk].

After describing your pages inside the `lib/base/routers/router.dart` file and running the shell script `bin/build_runner_build.sh`(or `bin/build_runner_watch.sh`), you can access the generated routes by using the `context.navigator` widget.

<div id="locatization"/>

### Localization

Your app supports [localization][localization_lnk] out of the box.

You define localizations by adding a translation file in the `lib/l10n/arb/[language_code].arb` directory. The `language_code` represents the code of the language you want to support (`en`, `zh`,`de`, ...). Inside that file, in JSON format, you define key-value pairs for your strings. **Make sure that all your translation files contain the same keys!**

If there are new keys added to the main translation file they can be propagated to the others by running the `bin/sync_translations.py` script. This script depends on the `pyyaml` library. If your python distribution does not include it you can install it by running `pip3 install pyyaml`.

Upon rebuild, your translations are auto-generated inside `lib/assets.dart`. In order to use them, you need to import the `l10n.dart` file from `lib/l10n/l10n.dart` and then access the translations from your BuildContext via `context.l10n.someTranslationKey` or `context.l10n.featureName.someTranslationKey`.

<div id="analytics"/>

### Analytics

[Firebase analytics][firebase_analytics_lnk] track how your app is used. Analytics are available for iOS, Android and Web and support flavors.

Before you start using analytics, you need to add platform specific configurations:
1. The `iOS` configuration files can be found at `ios/environments/[flavor]]/firebase/GoogleService-Info.plist`
2. For `Android` the configuration files are located at `android/app/src/[flavor]/google-services.json`
3. All `Web` analytics configurations can be found inside `lib/base/app/config/firebase_web_config.js`

Every flavor represents a separate Firebase project that will be used for app tracking. For each flavor, based on the targeted platforms you'll have to download the [configuration files][firebase_configs_lnk] and place them in the appropriate location mentioned above.

*Note*: When ran as `development` flavor, `.dev` is appended to the package name. Likewise, `.stag` is appended to the package name when using `staging` flavor. If using separate analytics for different flavors, make sure you specify the full package name with the correct extension (for instance: `com.companyname.projectname.dev` for the `dev` environment).

<div id="httpClient"/>

### Http client

Your project has integrated HTTP-client, using [dio][dio_lnk] and [retrofit][retrofit_lnk]. That helps you to easily communicate with remote APIs and use interceptors, global configuration, form fata, request cancellation, file downloading, timeout etc.

To use its benefits you should define a data model in `lib/base/models/`, using [json_annotation][json_annotation_lnk] and [json_serializable][json_serializable_lnk]. Define your remote data source in folder `lib/base/data_sources/remote/` with methods and real Url, using [retrofit][retrofit_lnk]. In your dependencies class (for example: `lib/feature_counter/di/counter_dependencies.dart` ) specify which data source you are going to use in every repository.

JWT-based authentication and token management is supported out of the box.

<div id="designSystem"/>

### Design system

A [design system][design_system_lnk] is a centralized place where you can define your app`s design.  This includes typography, colors, icons, images and other assets. It also defines the light and dark themes of your app. By using a design system we ensure that a design change in one place is reflected across the whole app.

To access the design system from your app, you have to import it from the following location`lib/app/base/theme/design_system.dart'`. After that, you can access different parts of the design system by using the BuildContext (for example: `context.designSystem.typography.headline1` or `context.designSystem.icons.someIcon`).

<div id="goldenTests"/>

### Golden tests

A [golden test][golden_test_lnk] lets you generate golden master images of a widget or screen, and compare against them so you know your design is always pixel-perfect and there have been no subtle or breaking changes in UI between builds. To make this easier, we employ the use of the [golden_toolkit][golden_toolkit_lnk] package.

To get started, you just need to generate a list of `LabeledDeviceBuilder` and pass it to the `runGoldenTests` function. That's done by calling `generateDeviceBuilder` with a label, the widget/screen to be tested, as well as a `Scenario`. They provide an optional `onCreate` function which lets us execute arbitrary behavior upon testing. Each `DeviceBuilder` will have two generated golden master files, one for each theme.

Due to the way fonts are loaded in tests, any custom fonts you intend to golden test should be included in `pubspec.yaml`

In order for the goldens to be generated, we have provided VS Code and IDEA run configurations, as well as an executable `bin/generate_goldens.sh`. The golden masters will be located in `goldens/light_theme` and `goldens/dark_theme`. The `failures` folder is used in case of any mismatched tests.

<div id="server"/>

### Server

Your app comes with a small preconfigured local server (written in Dart) that you can use for testing purposes or even expand it. It is built using [shelf][shelf_lnk], [shelf_router][shelf_router_lnk] and [shelf_static][shelf_static_lnk]. The server comes with several out-of-the-box APIs that work with the generated app.

In order to run the server locally, make sure to run `bin/start_server.sh`. The server should be running on `http://0.0.0.0:8080`, if not configured otherwise.

Some of the important paths are:

| Path | Contains |
| :------------ | :------------ |
| `bin/server/` | The root directory of the server |
| `bin/server/start_server.dart` | The main entry point of the server app |
| `bin/server/config.dart` | All server-related configurations and secrets are located here |
| `bin/server/controllers/` | All controllers are located here |
| `bin/server/models/` | Data models are placed here |
| `bin/server/repositories/` | Repositories that are used by the controllers reside here |

*Note:* When creating a new controller, make sure you also register it inside the `_registerControllers()` method in `start_server.dart`.

<div id="pushNotifications"/>

### Push notifications

[Firebase Cloud Messaging (FCM)][fcm_lnk] allows your integrating push notifications in your very own app. You can receive notifications while the app is in the foreground, background or even terminated. It even allows for event callbacks customizations, such when the app is opened via a notification from a specific state. All customizable callbacks can be found inside `lib/base/app/initialization/firebase_messaging_callbacks.dart`.

In order to make the notifications work on your target platform, make sure you first add the config file in the proper location (as described in the [**Analytic**](#analytics) section). For Web you also need to specify the `vapid` key inside `lib/base/app/config/app_constants.dart` and manually add the firebase web configuration to `web/firebase-messaging-sw.js`(for more info refer to [this link][fcm_web_config_ref]).

*Note:* On Android, FCM doesn't display heads-up notifications (notifications when the app is in foreground) by default. To display them while in app, we use a custom package called [flutter_local_notifications ][flutter_local_notifications_lnk]. This package also provides a way of customizing your notification icon which you can find at the `android/src/main/res/drawable` directory (supported types are `.png` and `.xml`).

*Note:* Since the app comes with a local server which can send notifications on demand, before using this feature, you need to create a server key for cloud messaging from the Firebase Console. Then you have to assign it to the `firebasePushServerKey` constant located inside the `bin/server/config.dart` file.

### Next Steps

* Define the branching strategy that the project is going to be using.
* Define application-wide loading state representation. It could be a progress bar, spinner, skeleton animation or a custom widget.

[rx_bloc_lnk]: https://pub.dev/packages/rx_bloc
[rx_bloc_info_lnk]: https://pub.dev/packages/rx_bloc#what-is-rx_bloc-
[extension_methods_lnk]: https://dart.dev/guides/language/extension-methods
[autoroute_lnk]: https://pub.dev/packages/auto_route
[autoroute_usage_lnk]: https://pub.dev/packages/auto_route#setup-and-usage
[localization_lnk]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[firebase_analytics_lnk]: https://pub.dev/packages/firebase_analytics
[firebase_configs_lnk]: https://support.google.com/firebase/answer/7015592
[design_system_lnk]: https://uxdesign.cc/everything-you-need-to-know-about-design-systems-54b109851969
[golden_test_lnk]: https://medium.com/flutter-community/flutter-golden-tests-compare-widgets-with-snapshots-27f83f266cea
[golden_toolkit_lnk]: https://pub.dev/packages/golden_toolkit
[retrofit_lnk]: https://pub.dev/packages/retrofit
[dio_lnk]: https://pub.dev/packages/dio
[json_annotation_lnk]: https://pub.dev/packages/json_annotation
[json_serializable_lnk]: https://pub.dev/packages/json_serializable
[fcm_lnk]: https://firebase.flutter.dev/docs/messaging/overview
[fcm_web_config_ref]: https://github.com/FirebaseExtended/flutterfire/blob/4c9b5d28de9eeb5ce76c856fbd0c7b3ec8615e45/docs/messaging/usage.mdx#web-tokens
[flutter_local_notifications_lnk]: https://pub.dev/packages/flutter_local_notifications
[shelf_lnk]: https://pub.dev/packages/shelf
[shelf_router_lnk]: https://pub.dev/packages/shelf_router
[shelf_static_lnk]: https://pub.dev/packages/shelf_static