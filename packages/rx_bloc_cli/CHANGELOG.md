## [5.5.3]
* Support `flutter 3.32`
* Bug fixes and stability improvements:
  - App: Screen rotation affects app (Landscape mode not prevented)
  - Forgotten password: navigation and mock deep links not working in some cases
  - Onboarding: No back button on Onboarding page
  - Onboarding: No back button on Confirm Phone Number screen
  - Onboarding: Info box on country search modal sheet when no results as present displayed as error instead of info
  - Onboarding: focus field on change email
  - Onboarding: change email screen is now a standalone page rather than a modal sheet
  - Onboarding: send new link on email verify page now hides when disabled
  - Onboarding: restarting the app during an unfinished onboarding flow performs a user login
  - Onboarding: back buttons displayed inconsistently between pages
  - Onboarding: Returning back from the verify phone screen and then visiting the screen again with same unconfirmed number results in `Phone number already in use` error
  - Onboarding: Continue button obstructed by keyboard on smaller screens
  - Profile screen: change email doesn't properly change email address
  - Showcase: Shimmer wrapper in demo not working
  - Showcase: MFA demo bottom button should ONLY display pin feature when pressed
  - Showcase: Canceling biometrics quits MFA instead of allowing user to enter pin code
  - Pin: Message after creating a pin informs the user that the pin has been updated instead of created
  - Pin: When on the Confirm Pin screen, typing a wrong pin displays a vague `Wrong pin` message
  - Pin: Pin code screen not working after idling for a minute (foreground or background)
  - Pin: Biometrics button not present on verify pin code screen when changing pin
  - Pin: Pin code screen not shown during cold start for an account with an already configured pin

## [5.5.2]
* Update generated project `go_router` dependency to `^15.1.0`

## [5.5.1]
* Fix issue with the generated project not properly building

## [5.5.0]
* Added change email feature in the generated project
* Added change phone number feature in the generated project
* Added Forgotten password feature in the generated project

## [5.4.1]
* Fix static analysis issue with multiline if statement brackets after linter update

## [5.4.0]
* Added `--enable-feature-onboarding` flag to configure an Onboarding/Registration flow for the project, including resuming Onboarding from a different device
* Fix issue where camera permission was not available on iOS devices for the QR scanner feature
* Added functionality on the profile page where the toggle switch for notifications prompts the user for notification permission when toggled
* Fixed an issue where the HTTP request for SSE was not canceled when the stream is closed

## [5.3.2]
* Fix issues in generated project related to pin code and biometrics authentication
* Update the fastlane file to fix compatibility issues with the latest flutter stable

## [5.3.1]
* Design uplift for the generated project

## [5.3.0]
* Replace golden tests dependency from `golden_toolkit` to [`alchemist`][alchemist_url] in generated projects
* Updated project dependencies
* Added `--enable-remote-translations` flag to configure remote translation lookup for localizations
* Redesigned the generated project profile page
* Added button on profile page for toggling biometric authentication
* Added integration test for QR scanner feature

## [5.2.0]
* Update generated project min supported iOS version to `16.0`
* Add a script for running integration tests with Patrol
* Added a showcase feature that groups all other showcase features in one place
* Add QR scanner feature as an option under the flag `--enable-feature-qr-scanner`
* Added `dart fix --apply .` to the project generation process
* Updates generated project dependencies version

## [5.1.0]
* Added Profile as an option under the flag `--enable-profile`
* Update ruby version for generated `github` workflows

## [5.0.1]
* Updates to github workflows supporting monorepo structure

## [5.0.0]
* Update generated project min supported iOS version to `13.0`
* Generated projects have their dependencies updated:
  * `rxdart` to `^0.28.0`
  * `rx_bloc` to `^6.0.0` (and related ecosystem packages)
  * `widget_toolkit` to `^0.2.0` (and related ecosystem packages)
  * `firebase_core` to `^3.4.0` (and related ecosystem packages)
  * `alice` to use a forked version until the official package is updated (see [issue](https://github.com/Prime-Holding/rx_bloc/pull/704#issuecomment-2340266154))

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
[alchemist_url]: https://pub.dev/packages/alchemist