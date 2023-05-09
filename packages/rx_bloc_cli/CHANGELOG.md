## [2.x.x]
* Added new event: `pop` for the `RouterBlocEvents` for enabling popping from a location
* Updated major versions of dependencies `go_router`, `go_router_builder`
* Add support for Dio 5 and fix related errors and warnings
* Update retrofit and retrofit_generator to make them compatible with dio 5

## [2.4.0]
* Added parameter `enable-social-logins` for social logins (Apple, Google, Facebook) integration
* Added parameter `enable-change-language` for enabling a translation of the project

## [2.3.0]
* Adding `EditAddressWidget` feature as example to `EditFieldsPage`

## [2.2.0]
* Update documentation
* Adding parameter `enable-feature-counter` for enabling the counter showcase as part of the project
* Adding parameter `enable-feature-deeplinks` for enabling the deep link example flow as part of the project
* Adding parameter `enable-feature-widget-toolkit` for enabling the showcase page for the `widget_toolkit` package as part of the project
* Bug fixing
* Integrate [widget_toolkit](https://pub.dev/packages/widget_toolkit)

## [2.1.0]
* Adding parameter `enable-feature-counter` for enabling the counter page example as part of the project
* Adding `Dashboard` feature as initial page after user login
* Bug fixing

## [2.0.0]
* `auto_route` and `auto_route_generator` were replaced by `go_router` and `go_router_builder`
* The navigation goes through the business layer using the `refreshListenable` and `redirect` properties of the `GoRouter`
* `Splash` screen initializing the application was implemented
* Deep-link navigation was implemented
* Add `spacing` as part of the `designSystem`
* ACL implementation added covering in-app navigation as well as an external (deep-link) navigation
* `Authentication`, `Permissions` and `Routing` are organized as libraries

## [1.4.1]
* Unit and golden test related fixes

## [1.4.0]
* Make the project name parameter a mandatory one
* Rename the 'org' parameter to 'organization'
* Rename the 'include-analytics' parameter to 'enable-analytics'
* Turn the 'enable-analytics' parameter off by default
* Remove the unused 'http-client' parameter
* Rebase the authentication interceptor on `QueuedInterceptor` and extract auxiliary use cases
* Convert use cases to services
* Update the local auth token data sources to not clear ALL preference data
* Updated to Dart 2.18 and newer dependencies

## [1.3.0]
* Add utility script to exclude files from LCOV coverage reports
* Import r_flutter and use it for localisation
* Implement error mapping
* Update the firebase dependency versions

## [1.2.0]
* Support flutter 3
* Fixes to generated project not properly building or displaying errors on hot restart
* Update dependencies of generated project to latest versions
* Update the design system to work as a theme extension
* Add Next Steps section to the generated project README file

## [1.1.3]
* Bump Android compileSdkVersion to the current version (32)

## [1.1.2]
* Fixes to generated iOS project

## [1.1.1]
* Stability improvements

## [1.1.0]
* Upgrade dependencies of generated project to support `flutter 2.5`
* Updated several inconsistencies in generated project readme file

## [1.0.0]
* Upgraded to `rx_bloc: 3.1.0` and `flutter_rx_bloc: 3.2.0`

## [0.0.5]
* Update generated project, adding following features:
    - Http-client (Dio by default)
    - Interceptors
    - Push Notifications via Firebase Cloud Messaging
    - Local server (written in Dart)

## [0.0.4]
* Update generated project with golden tests

## [0.0.3]
* Support null safety
* Update generated project with latest dependencies of following packages:
    - `build_runner: ^2.0.3`
    - `auto_route: ^2.2.0`
    - `auto_route_generator: ^2.0.1`
    - `flutter_rx_bloc: ^3.0.0`
    - `mockito: ^5.0.0`
    - `rx_bloc: ^3.0.0`
    - `rx_bloc_generator: ^5.0.0`
    - `rx_bloc_test: ^3.0.0`

## [0.0.2]
* Documentation improvements

## [0.0.1]
* Initial release
* Created projects include following features:
    - Flavors
    - Localization
    - State management with [rx_bloc](https://pub.dev/packages/rx_bloc)
    - Routing
    - Design system
    - Firebase Analytics
    - Unit tests
