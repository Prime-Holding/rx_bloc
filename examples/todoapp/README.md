# Table of contents

1. [Getting Started](#getting-started)
2. [Project structure](#project-structure)
3. [Architecture](#architecture)
4. [Routing](#routing)
   * [Deep linking](#deep-linking)
   * [Access Control List](#access-control-list)
5. [Adding a new feature](#adding-a-new-feature)
6. [Localization](#localization)
7. [Firebase Analytics](#analytics)
8. [Http client](#http-client)
9. [Design system](#design-system)
10. [Golden tests](#golden-tests)
11. [Server](#server)
12. [Push notifications](#push-notifications)
14. [Dev Menu](#dev-menu)
21. [Next Steps](#next-steps)

## Getting started

Before you start working on your app, make sure you familiarize yourself with the structure of the generated project and the essentials that are included with it.

*Note:* The app contains features that request data from API endpoints hosted on a local server. For the app to function properly, make sure the local server is up and running. For more info, check out the [server topic](#server).

## Project structure
| Classes and Libraries                            | Description                                                                                                   |
|---------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| **Application-Specific Classes**                  |                                                                                                               |
| lib/base/app                                  | The root widget used in the application entry points (main.dart, main_sit.dart, etc.)                         |
| lib/base/app/config                           | Environment-specific configurations and application-specific constants.                                      |
| lib/base/app/initialization                   | Initialization of Firebase, Push Notifications, Preferred Orientation, etc.                                    |
| lib/base/data_sources/local                   | Application-wide local data sources, such as shared preferences, secured storage, etc.                                  |
| lib/base/data_sources/remote                  | Application-wide remote data sources such as APIs. Here is placed all retrofit code.                                    |
| lib/base/theme/design_system                  | A catalog of colors, gradients, images (light and dark mode), and spacing used in the Flutter theme and widgets.        |
| lib/base/common_mappers 	                  | Application-wide mappers, responsible for mapping DTOs to business models such as Dio error mapper, platform error mapper, etc. |
| lib/base/common_ui_components                 | Application-wide reusable widgets (buttons, controls, list tiles, etc.)                                                |
| lib/base/data_sources/remote/interceptors	  | Custom interceptors that can monitor, rewrite, and retry calls.                                                 |
| lib/base/data_sources/remote/http_clinets     | Application-wide HTTP clients.                                                                                        |
| lib/base/common_blocs                         | Generic purpose BLoC classes used in more than one feature.                                                    |
| lib/base/common_services                      | Generic purpose service classes used in more than one feature.                                                 |
| lib/base/repositories                         | Repository classes of the application.                                                                        |
| lib/base/models                               | Business model classes of the application.                                                                        |
| lib/base/extensions                           | Application-specific utility functions.                                                                      |
| lib/base/di                                   | Application-wide dependency injection. All classes (BLoC, services, repositories, design system, config and data sources) are accessible from within each feature or project library. |
| **Library-Specific Classes**                     |                                                                                                               |
| lib/library_{name}                             | Library-specific UI components.                                                                               |
| lib/library_{name}/models                      | Business models representing the success and error state of this library.                                      |
| lib/library_{name}/blocs                       | Business Logic Component that manages the library-specific state.                                              |
| lib/library_{name}/services                    | Pure Dart classes responsible for domain-specific business logic of this library.                              |
| lib/library_{name}/repositories                | Pure Dart classes responsible for data provisioning regardless of the data source of this library.             |
| lib/library_{name}/data_sources                | Classes responsible for storing and retrieving data of this library.                                           |
| `Note:`                                           | A library may, or may not contain all components described above based on its needs. This structure should be treated as a guideline.                                            |
| **Feature-Specific Classes**                     |                                                                                                               |
| lib/feature_{name}                             | Feature-specific UI components.                                                                              |
| lib/feature_{name}/models                      | Business models representing the success and error state of this feature.                                      |
| lib/feature_{name}/blocs                       | Business Logic Component that manages the feature-specific state.                                              |
| lib/feature_{name}/services                    | Pure Dart classes responsible for domain-specific business logic of this feature.                              |
| `Note:`                                           | A feature may, or may not contain models based on its needs.                                                  |
| **Application-Specific Libraries**               |                                                                                                               |
| lib/lib_auth                                    | The OAuth2 (JWT) based authentication and token management library.                                           |
| lib/lib_permissions                             | The ACL based library that handles all the in-app routes and custom actions as well.                           |
| lib/lib_router                                  | Generally available router related classes. The main router of the app is lib/lib_router/routers/router.dart.  |
| lib/lib_router/routes                           | Declarations of all nested pages in the application are located here.                                          |
| lib/lib_dev_menu                                | A library that helps application debugging by easily set and access proxy debugging services Charles and Alice. |

## Architecture

For in-depth review of the following architecture watch [this][architecture_overview] presentation.

<img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_cli/example/docs/app_architecture.png" alt="Rx Bloc Architecture"></img>

## Routing

The routing throughout the app is handled by [GoRouter][gorouter_lnk].


You can use the [IntelliJ RxBloC Plugin][intellij_plugin], which automatically does all steps instead of you, or to manualy add your route to the `lib/lib_router/routes/routes.dart`. Once the route is added one of the following shell scripts `bin/build_runner_build.sh`(or `bin/build_runner_watch.sh`) needs to be executed.


The navigation is handled by the business layer `lib/lib_router/bloc/router_bloc` so that every route can be protected if needed.
You can [push][go_router_push], [pop][go_router_pop], [goToLocation][go_to_location] 
[push_replacement][go_router_push_replacement] or [go][go_router_go] as follows

```
context.read<RouterBlocType>().events.push(MyNewRoute())
```

```
context.read<RouterBlocType>().events.pop(Object())
```

```
context.read<RouterBlocType>().events.goToLocation('Location')
```

```
context.read<RouterBlocType>().events.pushReplacement(MyNewRoute())
```
or

```
context.read<RouterBlocType>().events.go(MyNewRoute())
```
### Deep linking

Your app is already configured to use deep links. Although you may still want to do some adjustments.

`iOS`
The configuration file can be found at `ios/Runner/Info.plist`
Under the `CFBundleURLTypes` key there are two things you may want to change:
1. `CFBundleURLName` unique URL used to distinguish your app from others that use the same scheme. The URL we build contains your `project name`, `organization name` and `domain name` you provided when setting up the project.
2. `CFBundleURLSchemes` the scheme name is your `organisation name` followed by `scheme`.

Example:

```
    <key>FlutterDeepLinkingEnabled</key>
    <true/>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>todoapp.primeholding.com</string>
        <key>CFBundleURLSchemes</key>
        <array>
        <string>primeholdingscheme</string>
        </array>
        </dict>
    </array>
```

You can test the deep-links on iOS simulator by executing the following command

Production
```
xcrun simctl openurl booted primeholdingscheme://todoapp.primeholding.com/deepLinks/1
```

UAT
```
xcrun simctl openurl booted primeholdinguatscheme://todoappuat.primeholding.com/deepLinks/1
```

SIT
```
xcrun simctl openurl booted primeholdingsitscheme://todoappsit.primeholding.com/deepLinks/1
```

Development
```
xcrun simctl openurl booted primeholdingdevscheme://todoappdevelopment.primeholding.com/deepLinks/1
```

`Android`
The configuration file can be found at `android/app/src/main/AndroidManifest.xml`
There is a metadata tag `flutter_deeplinking_enabled` inside `<activity>` tag with the `.MainActivity` name. You may want to change the host name which again contains your `project name`, `organization name` and `domain name` you provided when the project was set up.

See [Deep linking][deep_linking_lnk] documentation at flutter.dev for more information.

### Access Control List

Your app supports ACL out of the box, which means that the access to every page can be controlled remotely by the corresponding API endpoint `/api/permissions`

Expected API Response structure/data for anonymous users.

**Note**: The anonymous users have access to the splash route, but not to the **profile** route.
```
{
    'SplashRoute': true,
    'ProfileRoute': false,
    ...
}
```

Expected structure/data for authenticated users.

**Note**: The authenticated users have access to the splash and profile route.
```
{
    'SplashRoute': true,
    'ProfileRoute': true,
    ...
}
```


You can use the [IntelliJ RxBloC Plugin][intellij_plugin], which automatically does all steps instead of you, or to manualy add the permission for your route to the `lib/lib_permissions/models/route_permissions.dart`.

## Adding a new feature

You can manually create new features as described above, but to speed up the product development you can use the [IntelliJ RxBloC Plugin][intellij_plugin], which not just creates the feature structure but also integrates it to the prefered routing solution (auto_route, [go_router][gorouter_lnk] or none)

If you decide to create your feature manually without using the plugin here is all necessary steps you should do to register this feature and to be able to use it in the application:
1. Add your feature path in the `RoutesPath` class which resides under  `lib/lib_router/models/routes_path.dart`:
```
   class RoutesPath {
      static const myNewFeature = ‘my-new-feature’;
      ...
   }
```

2. Add you feature permission name in the `RoutePermissions` class which resides under `lib/lib_permissions/models/route_permissions.dart`:
```
   class RoutePermissions {
       static const myNewFeature = MyNewFeatureRoute’;
       ...
   }
```

3. Next step is to declare the new features as part of the `RouteModel` enumeration which resides under `lib/lib_router/models/route_model.dart`:
```
   enum RouteModel {
       myNewFeature(
           pathName: RoutesPath.myNewFeature
           fullPath: '/my-new-feature',
           permissionName: RoutePermissions.myNewFeature,
       ),
       ...
   }
```

4. As a final step the route itself should be created. All routes are situated under `lib/lib_router/routes/` folder which contains different route files organised by the application flow. If the new route doesn’t fit the existing application flows it can be added to the `routes.dart` file which is the default file used by the IntelliJ plugin.
```
   @TypedGoRoute<MyFeatureRoute>(path: RoutesPath.myNewFeature)
   @immutable
   class MyFeatureRoute extends GoRouteData implements RouteDataModel {
       const MyFeatureRoute();
   
       @override
       Page<Function> buildPage(BuildContext context, GoRouterState state) =>
           MaterialPage(
             key: state.pageKey,
             child: const MyFeaturePage(),
           );
   
       @override
       String get permissionName => RouteModel.myNewFeature.permissionName;
   
       @override
       String get routeLocation => location;
   }
```

Now the new route can be navigated by calling one of the `RouterBloc` events (`go(...)`, `push(...)`).
Example:
```
context.read<RouterBlocType>().go(const MyFeatureRoute())
```

For more information you can refer to the official [GoRouter][gorouter_lnk] and [GoRouterBuilder][gorouter_builder_lnk] documentation.

## Localization

Your app supports [localization][localization_lnk] out of the box.

You define localizations by adding a translation file in the `lib/l10n/arb/[language_code].arb` directory. The `language_code` represents the code of the language you want to support (`en`, `zh`,`de`, ...). Inside that file, in JSON format, you define key-value pairs for your strings. **Make sure that all your translation files contain the same keys!**

If there are new keys added to the main translation file they can be propagated to the others by running the `bin/sync_translations.py` script. This script depends on the `pyyaml` library. If your python distribution does not include it you can install it by running `pip3 install pyyaml`.

Upon rebuild, your translations are auto-generated inside `lib/assets.dart`. In order to use them, you need to import the `l10n.dart` file from `lib/l10n/l10n.dart` and then access the translations from your BuildContext via `context.l10n.someTranslationKey` or `context.l10n.featureName.someTranslationKey`.

#### Remote localization lookup

Localization lookups are also supported. That means that you can request any remote localizations from a dedicated translations endpoint at app start (by default, all remote localizations are fetched during the splash screen). Grabbing any remote localization for existing features will replace the local translations with new ones.

The endpoint retrieving the updated translations should return an object containing key-value pairs (under the `translations` key) where the key is the language code, while the value is a translation file object containing values to be overwritten.

Example response:
```json
{
   "translations":{
      "en":{
         "_ok":"Okay",
         "login___logIn":"Login via email"
      },
      "bg":{
         "_ok":"ok",
         "login___logIn":"Вход с имейл"
      }
   }
}
```

One thing to note is that the keys in the translations follow a naming scheme which consists of three parts: the feature name, separator and the translation key. The feature name by default represents the feature under which the translations are categorized followed by two underscores. It is optional and if omitted, the key overrides are placed within the main translations. The separator is a character used to separate the feature name and the translation key. The translation key is the key within the specified feature used in the app.

Example:
```
Translations feature: feature_notifications
Feature name: notifications__
Separator: _
Translation key: ok
Full translation key (feature name+separator+translation key): notifications___ok
```

## Http client

Your project has integrated HTTP-client, using [dio][dio_lnk] and [retrofit][retrofit_lnk]. That helps you to easily communicate with remote APIs and use interceptors, global configuration, form fata, request cancellation, file downloading, timeout etc.

To use its benefits you should define a data model in `lib/base/models/`, using [json_annotation][json_annotation_lnk] and [json_serializable][json_serializable_lnk]. Define your remote data source in folder `lib/base/data_sources/remote/` with methods and real Url, using [retrofit][retrofit_lnk]. In your dependencies class (for example: `lib/feature_counter/di/counter_dependencies.dart` ) specify which data source you are going to use in every repository.

JWT-based authentication and token management is supported out of the box.

## Design system

A [design system][design_system_lnk] is a centralized place where you can define your app`s design.  This includes typography, colors, icons, images and other assets. It also defines the light and dark themes of your app. By using a design system we ensure that a design change in one place is reflected across the whole app.

To access the design system from your app, you have to import it from the following location`lib/app/base/theme/design_system.dart'`. After that, you can access different parts of the design system by using the BuildContext (for example: `context.designSystem.typography.headline1` or `context.designSystem.icons.someIcon`).

<div id="goldenTests"/>

## Golden tests

A [golden test][golden_test_lnk] lets you generate golden master images of a widget or screen, and compare against them so you know your design is always pixel-perfect and there have been no subtle or breaking changes in UI between builds. To make this easier, we employ the use of the [golden_toolkit][golden_toolkit_lnk] package.

To get started, you just need to generate a list of `LabeledDeviceBuilder` and pass it to the `runGoldenTests` function. That's done by calling `generateDeviceBuilder` with a label, the widget/screen to be tested, as well as a `Scenario`. They provide an optional `onCreate` function which lets us execute arbitrary behavior upon testing. Each `DeviceBuilder` will have two generated golden master files, one for each theme.

Due to the way fonts are loaded in tests, any custom fonts you intend to golden test should be included in `pubspec.yaml`

In order for the goldens to be generated, we have provided VS Code and IDEA run configurations, as well as an executable `bin/generate_goldens.sh`. The golden masters will be located in `goldens/light_theme` and `goldens/dark_theme`. The `failures` folder is used in case of any mismatched tests.

<div id="server"/>

## Dev Menu

Dev menu brick is a useful feature when it comes to debugging your app and/or easily accessing some common development specific information and settings. You can define secret inputs which after being triggered a defined number of times will execute a callback. From that callback you can define any app-specific behaviors like navigating to a screen, displaying a dev modal sheet with additional data or your own behaviors.

### Widgets

Within the `dev_menu` brick you can find the `AppDevMenuGestureDetector` widget and the `showDevMenuBottomSheet` function.

#### AppDevMenuGestureDetector

The `AppDevMenuGestureDetector` widget is a widget that is listening for user interactions (quick taps or long taps) and as a result executes a callback (`onDevMenuPresented`) once a certain amount of interactions has been made.

As a good use case, you can wrap your page widget with this widget so you are able to access the functionality while on the same page.

```dart
  AppDevMenuGestureDetector.withDependencies(
    context,
    navKey!,
    child: materialApp,
      onDevMenuPresented: () {
        showAppDevMenuBottomSheet(
          context.read<AppRouter>().rootNavigatorKey.currentContext!,
        );
      },
  );

```
By default after you trigger  `AppDevMenuGestureDetector` you only need to add your proxy ip and restart app so you are all set to use Charles.
Alice is working right out of the box.

`Note:` To disable dev menu you only need to edit run configuration (Development or SIT) and remove `--dart-define="ENABLE_DEV_MENU=true"` from additional run arguments.




## Next Steps

* Define the branching strategy that the project is going to be using.
* Define application-wide loading state representation. It could be a progress bar, spinner, skeleton animation or a custom widget.

[rx_bloc_lnk]: https://pub.dev/packages/rx_bloc
[rx_bloc_info_lnk]: https://pub.dev/packages/rx_bloc#what-is-rx_bloc-
[extension_methods_lnk]: https://dart.dev/guides/language/extension-methods
[gorouter_lnk]: https://pub.dev/packages/go_router
[gorouter_builder_lnk]: https://pub.dev/packages/go_router_builder
[gorouter_usage_lnk]: https://pub.dev/packages/go_router#documentation
[localization_lnk]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[firebase_analytics_lnk]: https://pub.dev/packages/firebase_analytics
[firebase_configs_lnk]: https://support.google.com/firebase/answer/7015592
[firebase_setup_lnk]: https://firebase.google.com/docs/flutter/setup
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
[deep_linking_lnk]: https://docs.flutter.dev/development/ui/navigation/deep-linking
[gorouter_deep_linking_lnk]: https://pub.dev/documentation/go_router/latest/topics/Deep%20linking-topic.html
[architecture_overview]: https://www.youtube.com/watch?v=nVX4AzeuVu8
[intellij_plugin]: https://plugins.jetbrains.com/plugin/16165-rxbloc
[go_router_push]: https://pub.dev/documentation/go_router/latest/go_router/GoRouter/push.html
[go_router_go]: https://pub.dev/documentation/go_router/latest/go_router/GoRouterHelper/go.html
[go_to_location]: https://pub.dev/documentation/go_router/latest/go_router/GoRouterHelper/go.html
[go_router_pop]: https://pub.dev/documentation/go_router/latest/go_router/GoRouterHelper/pop.html
[fastlane_lnk]: https://docs.fastlane.tools/
[booking_app_lnk]: https://github.com/Prime-Holding/rx_bloc/blob/develop/examples/booking_app/fastlane/Fastfile
[go_router_push_replacement]: https://pub.dev/documentation/go_router/latest/go_router/GoRouterHelper/pushReplacement.html
[patrol_pub_lnk]: https://pub.dev/packages/patrol
[patrol_cli_pub_lnk]: https://pub.dev/packages/patrol_cli
[patrol_native_integration_lnk]: https://patrol.leancode.pl/getting-started#integrate-with-native-side
[rx_bloc_cli_cd_setup_lnk]: docs/continuous_delivery.md