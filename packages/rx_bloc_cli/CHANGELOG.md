## [5.1.0]
* Added GitLab as a CI/CD option under the flag `--cicd` (`fastlane` (default), `github`, `codemagic`, `gitlab`, `none`)

## [5.0.0]
Generated projects have their dependencies updated:
* `rx_bloc` to `^6.0.0`
* `rxdart` to `^0.28.0`

## [4.0.1]
* Added [README][patrol_integration_test_url] about Patrol Integration Test.
* Fixed the compile errors of the generated projects.

## [4.0.0]
Contains breaking changes
* The `--enable-auth-matrix` option is removed in favour of the [--enable-mfa][mfa_doc_url] (Multi-Factor Authentication) capability.
* The `go_router` package is upgraded to version `^14.2.1`
* The `flutter_local_notifications` package is upgraded to version `^17.2.1+2`

## [3.8.1]
* Added reference in [example documentation][golden_tests_doc_url] about [writing golden tests for smart widgets with dependency injection][golden_tests_doc_url].

## [3.8.0]
* Added functionality to exclude smart widgets dependency injection components during golden tests. [Check out the detailed documentation.][golden_tests_doc_url]

## [3.7.0]
Updated environment variable names used in CI/CD functionality:
- `MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD` -> `CREDENTIAL_ENCRYPTION_PASSWORD`
- `MOBILE_DISTRIBUTION_REPOSITORY_ACCESS_SECRET` -> `CREDENTIAL_REPOSITORY_ACCESS_SECRET`

## [3.6.2]
* Updated names and caching strategies of github workflows to match it's usage
* Fastfile: credentials are now removed after a build/deployment is complete

## [3.6.1]
* Updated Github workflow files generated with the `github` cicd flag

## [3.6.0]
* Added [Codemagic][code_magic_url] as a CI/CD option under the flag --cicd (`fastlane` (default), `github`, `codemagic`, `none`)

## [3.5.3]
* Updated `widget_toolkit` dependencies in generated project
* Improvements and bugfixes to generated projects

## [3.5.2]
* Updated architecture diagram
* Updated CD documentation
* Security improvements to scripts generated with the `create_distribution` command

## [3.5.1]
* Stability improvements

## [3.5.0]
* Introduce the rx_bloc_cli `create_distribution` command, which bootstraps a project containing encryption scripts, certificates and provisioning profiles needed for iOS and Android application distribution. Heavily inspired by the https://codesigning.guide/
* Added `continuous_delivery.md` guide for setting up project specific CD

## [3.4.1]
* Update generated projects to support latest flutter version (`3.19`)

## [3.4.0]
* Use `flutter create` to generate the native iOS and Android directories to ensure compatibility in the future

## [3.3.1]
* Update the build_custom fastlane task so that if the required environment variables do not exist the user will be prompted to enter their values
* Convert the expected fastlane environment variables to uppercase
* Apply c4model (Component Diagram) specifics to the Architectural Diagram 

## [3.3.0]
* Added Github as a CI/CD option under the flag `--cicd` (`fastlane` (default), `github`, `none`)
* Added remote translation lookup for localizations
* Updates to `analytics` feature - added crash reporting support and screen view logging
* Update generated project dependencies 

## [3.2.0]
* Added Auth Matrix as an option under the flag `--enable-auth-matrix`
* Make `AppBar` on pin code screen transparent
* Update generated project dependencies

## [3.1.2]
* Update generated project dependencies
* Fix OTP screen not showing on login

## [3.1.1]
* Fix generated project not properly building when `pin_code` is disabled

## [3.1.0]
* Added Fastlane as a CI/CD option under the flag `--cicd` (`fastlane` (default), `none`)
* Added PIN code as an option under the flag `--enable-pin-code`
* Introduce two new flavors (`sit` and `uat`) and remove `staging` flavor

## [3.0.1]
* Generated project now uses the adaptive dialog introduced in Flutter `3.13.0`
* Fixed integration test showcase when OTP feature is enabled

## [3.0.0]
Contains breaking changes
* Migrated command parameters from options to flags
```sh
# < 3.0.0
--enable-login=true
--enable-social-logins=false
# = 3.0.0
--enable-login
--no-enable-social-logins
```
* `EnvironmentConfig` is transformed to enchanced enum
* `ErrorModel`, `GenericErrorModel`, `UnknownErrorModel` are moved to `widget_toolkit`'s models
* Updated project dependencies
* Added interactive configuration flag `--interactive` (enabled by default)
* Login with email can be enabled with flag `--enable-login` (enabled by default)
* OTP can be enabled  with flag `--enable-otp` (disabled by default)
* Improve notifications infrastructure

## [2.7.1]
* Replaced local `ErrorModel`, `GenericErrorModel` and `UnknownErrorModel` with the ones from `widget_toolkit` package

## [2.7.0]
* Added parameter `enable-dev-menu` for enabling dev menu (proxy debugging using Alice and Charles)

## [2.6.1]
* Fixed automated tests not running when analytics is enabled
* Fixed android compilation issues 

## [2.6.0]
* Added parameter `enable-patrol` for enabling patrol package for integration tests
* Added SSE communication facilities template
* Updated to Dart 3.0
* Fix android compatibility with the latest java and gradle versions

## [2.5.0]
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
* Integrate [widget_toolkit][widget_toolkit_url]

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
    - State management with [rx_bloc][rx_bloc_url]
    - Routing
    - Design system
    - Firebase Analytics
    - Unit tests

---

[rx_bloc_url]: https://pub.dev/packages/rx_bloc
[widget_toolkit_url]: https://pub.dev/packages/widget_toolkit
[code_magic_url]: https://codemagic.io/start/
[example_project_readme_doc_url]: https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/README.md
[golden_tests_doc_url]: https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/golden_tests.md
[mfa_doc_url]:https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/mfa.md
[patrol_integration_test_url]: https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/patrol_integration_test.md