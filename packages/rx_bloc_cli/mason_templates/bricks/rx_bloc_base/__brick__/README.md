# {{#titleCase}}{{project_name}}{{/titleCase}}

## Project structure

| Path | Contains |
| ------------ | ------------ |
| `lib/base/` | Common code used on more than one **feature** in the project. |
| `lib/base/common_blocs/` | Global [BLoCs](https://pub.dev/packages/rx_bloc#what-is-rx_bloc-) |
| `lib/base/common_ui_components/` | Reusable widgets (buttons, controls etc) |
| `lib/base/common_use_cases/` | Global UseCases |
| `lib/base/extensions/` | Global [extension methods](https://dart.dev/guides/language/extension-methods) |
| `lib/base/models/` | Data models used in the project |
| `lib/base/remote_data_sources/` | External data sources like APIs. Here is placed all [retrofit](https://pub.dev/packages/retrofit) code. |
| `lib/base/local_data_sources/` | Local data sources, such as shared preferences, secured storage etc. |
| `lib/base/repositories/` | Repositories used to fetch and persist models.
| `lib/base/routers/` | All [routers](https://pub.dev/packages/auto_route#setup-and-usage) are placed here. The main [router](https://pub.dev/packages/auto_route#setup-and-usage) of the app is `lib/base/routers/router.dart`. |
| `lib/base/routers/guards/` | The routers' [guards](https://pub.dev/packages/auto_route#setup-and-usage) of the app are placed here. |
| `lib/feature_X/` | Feature related classes |
| `lib/feature_X/blocs` | Feature related [BLoCs](https://pub.dev/packages/rx_bloc#what-is-rx_bloc-) |
| `lib/feature_X/use_cases/` | Feature related UseCases |
| `lib/feature_X/ui_components/` | Feature related custom widgets |
| `lib/feature_X/views/` | Feature related pages and forms |
| `lib/theme/` | The custom theme of the app |
| `lib/main.dart` | The main file of the app. If there are more that one main file, each of them is related to separate flavor of the app. |

## Feature structure

Each feature represent a separate flow in the app. They can compose one or more pages/screens. **Each page/screen MUST BE implemented as a StatelessWidget**. If some page/screen needs to be stateful, its state is placed in a BLoC. If the BLoC become too big and complex, some of its logic can be offloaded to one or more usecases.
