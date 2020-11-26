# FlutterRxBlocScaffold

## Project structure

| Path | Contains |
| ------------ | ------------ |
| `lib/base/` | Common code used on more than one **feature** in the project. |
| `lib/base/common_blocs/` | Global [BLoCs](https://pub.dev/packages/rx_bloc#business-logic-layer---bloc) |
| `lib/base/common_ui_components/` | Reusable widgets (buttons, controls etc) |
| `lib/base/common_use_cases/` | Global [UseCases](https://pub.dev/packages/rx_bloc#shared-business-logic-layer---service) |
| `lib/base/extensions/` | Global [extension methods](https://dart.dev/guides/language/extension-methods) |
| `lib/base/models/` | Data models used in the project |
| `lib/base/remote_data_sources/` | External data sources like APIs. Here is placed all [retrofit](https://pub.dev/packages/retrofit) code. |
| `lib/base/local_data_sources/` | Local data sources, such as shared preferences, secured storage etc. |
| `lib/base/repositories/` | [Repositories](https://pub.dev/packages/rx_bloc#data-layer---repository) used to fetch and persist models.
| `lib/base/routers/` | All [routers](https://pub.dev/packages/auto_route#setup-and-usage) are placed here. The main [router](https://pub.dev/packages/auto_route#setup-and-usage) of the app is `lib/base/routers/router.dart`. |
| `lib/base/routers/guards/` | The routers' [guards](https://pub.dev/packages/auto_route#setup-and-usage) of the app are placed here. |
| `lib/feature_X/` | Feature related classes |
| `lib/feature_X/blocs` | Feature related [BLoCs](https://pub.dev/packages/rx_bloc#business-logic-layer---bloc) |
| `lib/feature_X/use_cases/` | Feature related [UseCases](https://pub.dev/packages/rx_bloc#shared-business-logic-layer---service) |
| `lib/feature_X/ui_components/` | Feature related custom widgets |
| `lib/feature_X/views/` | Feature related pages and forms |
| `lib/theme/` | The custom theme of the app |
| `lib/main.dart` | The main file of the app. If there are more that one main file, each of them is related to separate flavor of the app. |

## Feature structure

Each feature represent a separate flow in the app. They can compose one or more pages/screens. **Each page/screen MUST BE implemented as a StatelessWidget**. If some page/screen needs to be stateful, its state is placed in a BLoC. If the BLoC become too big and complex, some of its logic can be offloaded to one or more usecases.

## How to use "the template"
1. Clone the project structure:

  - If the project's repo exists, clone the repo and enter to the folder. Create a develop branch if it is not existing. Then execute next command:
  ```
  git archive --format=tar --remote=ssh://git@gitlab.programista.pro:22122/codebase/flutter/flutter-scaffold.git HEAD | tar xf -
  ```

  - If the project's repo is empty. Execute next commands:
  ```
  git clone ssh://git@gitlab.programista.pro:22122/codebase/flutter/flutter-scaffold.git <NEW_PROJECT_NAME>
  cd <NEW_PROJECT_NAME>
  rm -fr .git
  git init
  ```
  
2. Run the create project:

  - With UI tests
  You have to uncomment the next rows in pubspec.yaml:
  ```
  # flutter_driver:
  #   sdk: flutter
  ```
  Then run next command:
  ```
  ./create.sh --project-name <PROJECT_NAME> --org com.primeholding --with-driver-test
  ```
  
  - Without UI tests
  Run next command:
  ```
  ./create.sh --project-name <PROJECT_NAME> --org com.primeholding
  ```

3. Push the changes to the remote
If the project's repo is empty, add the repo as a remote.
Push the current branch to the remote.