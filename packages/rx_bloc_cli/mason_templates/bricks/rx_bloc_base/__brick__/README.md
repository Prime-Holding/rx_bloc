# {{#titleCase}}{{project_name}}{{/titleCase}}

## Project structure

| Path | Contains |
| ------------ | ------------ |
| `lib/base/` | Common code used on more than one **feature** in the project. |
| `lib/base/common_blocs/` | Global [BLoCs][rx_bloc_info_lnk]|
| `lib/base/common_ui_components/` | Reusable widgets (buttons, controls etc) |
| `lib/base/common_use_cases/` | Global UseCases |
| `lib/base/extensions/` | Global [extension methods][extension_methods_lnk] |
| `lib/base/models/` | Data models used in the project |
| `lib/base/remote_data_sources/` | External data sources like APIs. Here is placed all [retrofit][retrofit_lnk] code. |
| `lib/base/local_data_sources/` | Local data sources, such as shared preferences, secured storage etc. |
| `lib/base/repositories/` | Repositories used to fetch and persist models.
| `lib/base/routers/` | All [routers][autoroute_usage_lnk] are placed here. The main [router][autoroute_usage_lnk] of the app is `lib/base/routers/router.dart`. |
| `lib/base/routers/guards/` | The routers' [guards][autoroute_usage_lnk] of the app are placed here. |
| `lib/base/theme/` | The custom theme of the app |
| `lib/feature_X/` | Feature related classes |
| `lib/feature_X/blocs` | Feature related [BLoCs][rx_bloc_info_lnk] |
| `lib/feature_X/use_cases/` | Feature related UseCases |
| `lib/feature_X/ui_components/` | Feature related custom widgets |
| `lib/feature_X/views/` | Feature related pages and forms |
| `lib/main.dart` | The main file of the app. If there are more that one main file, each of them is related to separate flavor of the app. |

## Feature structure

Each feature represents a separate flow in the app. They can be composed of one or more pages (screens) placed inside the features `views` directory. **Every page (screen) should be implemented as a Stateless Widget.**

The logic of each page should be placed into its own [BLoC][rx_bloc_lnk]. This is desired especially if the page has to be a **Stateful Widget**. The BLoC is placed inside the `blocs` directory. In order for the BLoC to be more readable, its implementation details can be offloaded to its own extensions file ( `[bloc_name]_extensions.dart`, placed inside the same directory) or one or more usecases.

## Architecture
<img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_cli/mason_templates/bricks/rx_bloc_base/__brick__/docs/app_architecture.jpg" alt="Rx Bloc Architecture"></img>

### Navigation

Navigation throughout the app is handled by [Auto Route][autoroute_lnk].

After describing your pages inside the `lib/base/routers/router.dart` file and running the shell script `bin/build_runner_build.sh`(or `bin/build_runner_watch.sh`), you can access the generated routes by using the `context.navigator` widget.

### App localization

You app supports [localization][localization_lnk] out of the box.

You define localizations by adding a translation file in the `lib/l10n/arb/app_[language_code].arb` directory. The `language_code` represents the code of the language you want to support (`en`, `zh`,`de`, ...). Inside that file, in JSON format, you define key-value pairs for your strings. **Make sure that all your translation files contain the same keys!**

Upon rebuild, your translations are auto-generated inside `.dart_tool/flutter_gen/gen_l10n`. In order to use them, you need to import the `l10n.dart` file from `lib/l10n/l10n.dart` and then access the translations from your BuildContext via `context.l10n.someTranslationKey`.

{{#analytics}}
### Analytics

[Firebase analytics][firebase_analytics_lnk] track how your app is used. Analytics are available for iOS, Android and Web and support flavors.

Before you start using analytics, you need to add platform specific configurations:
1. The `iOS` configuration files can be found at `ios/Runner/Firebase/[flavor]/GoogleService-Info.plist`
2. For `Android` the configuration files are located at `android/app/src/[flavor]/google-services.json`
3. All `Web` analytics configurations can be found inside `lib/base/app/config/firebase_web_config.js`

Every flavor represents a separate Firebase project that will be used for app tracking. For each flavor, based on the targeted platforms you'll have to download the [configuration files][firebase_configs_lnk] and place them in the appropriate location mentioned above.

{{/analytics}}
### Design system

A [design system][design_system_lnk] is a centralized place where you can define your apps design.  This includes typography, colors, icons, images and other assets. It also defines the light and dark themes of your app. By using a design system we ensure that a design change in one place is reflected across the whole app.

To access the design system from your app, you have to import it from the following location`lib/app/base/theme/design_system.dart'`. After that, you can access different parts of the design system by using the BuildContext (for example: `context.designSystem.typography.headline1` or `context.designSystem.icons.someIcon`).

[rx_bloc_lnk]: https://pub.dev/packages/rx_bloc
[rx_bloc_info_lnk]: https://pub.dev/packages/rx_bloc#what-is-rx_bloc-
[extension_methods_lnk]: https://dart.dev/guides/language/extension-methods
[retrofit_lnk]: https://pub.dev/packages/retrofit
[autoroute_lnk]: https://pub.dev/packages/auto_route
[autoroute_usage_lnk]: https://pub.dev/packages/auto_route#setup-and-usage
[localization_lnk]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[firebase_analytics_lnk]: https://pub.dev/packages/firebase_analytics
[firebase_configs_lnk]: https://support.google.com/firebase/answer/7015592
[design_system_lnk]: https://uxdesign.cc/everything-you-need-to-know-about-design-systems-54b109851969
