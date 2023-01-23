## [1.4.0] - January 23, 2023
* Make the project name parameter a mandatory one
* Rename the 'org' parameter to 'organization'
* Rename the 'include-analytics' parameter to 'enable-analytics'
* Turn the 'enable-analytics' parameter off by default
* Remove the unused 'http-client' parameter
* Rebase the authentication interceptor on `QueuedInterceptor` and extract auxiliary use cases
* Convert use cases to services
* Update the local auth token data sources to not clear ALL preference data
* Updated to Dart 2.18 and newer dependencies

## [1.3.0] - November 29, 2022
* Add utility script to exclude files from LCOV coverage reports
* Import r_flutter and use it for localisation
* Implement error mapping
* Update the firebase dependency versions

## [1.2.0] - October 27, 2022
* Support flutter 3
* Fixes to generated project not properly building or displaying errors on hot restart
* Update dependencies of generated project to latest versions
* Update the design system to work as a theme extension
* Add Next Steps section to the generated project README file

## [1.1.3] - Jun 01, 2022
* Bump Android compileSdkVersion to the current version (32)

## [1.1.2] - December 23, 2021
* Fixes to generated iOS project

## [1.1.1] - October 19, 2021
* Stability improvements

## [1.1.0] - October 19, 2021
* Upgrade dependencies of generated project to support `flutter 2.5`
* Updated several inconsistencies in generated project readme file

## [1.0.0] - July 09, 2021
* Upgraded to `rx_bloc: 3.1.0` and `flutter_rx_bloc: 3.2.0`

## [0.0.5] - June 29, 2021
* Update generated project, adding following features:
    - Http-client (Dio by default)
    - Interceptors
    - Push Notifications via Firebase Cloud Messaging
    - Local server (written in Dart)

## [0.0.4] - June 14, 2021
* Update generated project with golden tests

## [0.0.3] - May 28, 2021
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

## [0.0.2] - May 10, 2021
* Documentation improvements

## [0.0.1] - April 28, 2021
* Initial release
* Created projects include following features:
    - Flavors
    - Localization
    - State management with [rx_bloc](https://pub.dev/packages/rx_bloc)
    - Routing
    - Design system
    - Firebase Analytics
    - Unit tests
