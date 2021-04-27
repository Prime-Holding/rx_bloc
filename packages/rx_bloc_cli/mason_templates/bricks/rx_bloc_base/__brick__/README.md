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
The logic of each page should be placed into its own [BLoC][rx_bloc_lnk]. This is desired especially if the page has to be a **Stateful Widget**. The BLoC is placed inside the `blocs` directory. In order for the BLoC to be more readable, parts of code can be replaced with extension methods placed in the appropriate file `[bloc_name]_extensions.dart` in the same directory. If the BLoC become too big and complex, some of its logic can be offloaded to one or more usecases.

### Auto Route

Navigation throughout the app is handled by [Auto Route][autoroute_lnk].
After describing your pages inside the `lib/base/routers/router.dart` file and running the build command `flutter packages pub run build_runner build`, you can access the generated routes by using the `ExtendedNavigator.root` widget.

### App localization

You app supports [localization][localization_lnk] from the get-go.
You define localizations by adding a translation file in the `lib/l10n/arb/app_[language_code].arb` directory. The `language_code` represents the code of the language you want to support (`en`, `zh`,`de`, ...). Inside that file, in JSON format, you define key-value pairs for your strings. **Make sure that all your translation files contain the same keys!**
Upon rebuild, your translations are ready to be used. In order to use them, you need to import the `l10n.dart` file from `lib/l10n/l10n.dart` and then access the translations from your BuildContext via `context.l10n.someTranslationKey`.

[rx_bloc_lnk]: https://pub.dev/packages/rx_bloc
[rx_bloc_info_lnk]: https://pub.dev/packages/rx_bloc#what-is-rx_bloc-
[extension_methods_lnk]: https://dart.dev/guides/language/extension-methods
[retrofit_lnk]: https://pub.dev/packages/retrofit
[autoroute_lnk]: https://pub.dev/packages/auto_route
[autoroute_usage_lnk]: https://pub.dev/packages/auto_route#setup-and-usage
[localization_lnk]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization