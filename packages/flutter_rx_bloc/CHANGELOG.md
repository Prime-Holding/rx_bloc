## [4.0.0] - September 24, 2021
* Support Flutter `2.5`
* Updated `rxdart` to use version `0.27.2`
* [BREAKING] Changed signature of [RxResultBuilder.buildError] to `Widget Function(BuildContext, Exception, B)`

## [3.2.0] - July 09, 2021
* Added widget `RxLoadingBuilder`

## [3.1.0] - June 01, 2021
* Fix infinite feedback loop issue with RxTextFormFieldBuilder
* Nullability improvements for RxTextFormFieldBuilder
* Add the ability to chose how the cursor in RxTextFormFieldBuilder behaves, [look at this PR for more information](https://github.com/Prime-Holding/rx_bloc/pull/151)
* Fixed issue with RxBlocListener not executing callback when the incoming element is the same as the previous one

## [3.0.0] - May 21, 2021
* Support Flutter `2.2`
* Updated `rxdart` to use version `0.27.0`

## [2.0.0] - March 10, 2021
* Migrated to Flutter `2.0` and Dart `2.12` (null-safety).

## [1.2.1] - February 01, 2021
* Fix static code analysis issues

## [1.2.0] - January 29, 2021
* Updated Unit Tests
* Added a [puppy example project](https://github.com/Prime-Holding/rx_bloc/tree/develop/examples/favorites_advanced/rx_bloc_favorites_advanced) for the [medium article](https://medium.com/prime-holding-jsc/building-complex-apps-in-flutter-with-the-power-of-reactive-programming-54a38fbc0cde)
* Added new widgets: RxUnfocuser, RxFormFieldBuiler, RxTextFormFieldBuilder
* Added RxInputDecorationData
* Added RxFieldException

## [1.1.2] - December 08, 2020
* Stability improvements

## [1.1.1] - December 02, 2020
* Consolidated rx_bloc ecosystem [in one repository](https://github.com/Prime-Holding/rx_bloc)
* Applied strict static code analysis
* Updated example

## [1.1.0] - August 20, 2020
* Reorganized as a [library package](https://dart.dev/guides/libraries/create-library-packages#organizing-a-library-package)
* Update package dependencies

## [1.0.0] - August 7, 2020

* Added RxResultBuilder
* Updated README file
* Updated example
* Updated Unit Tests

## [0.1.2] - March 19, 2020

* Update package dependencies

## [0.1.1] - March 19, 2020

* Update package dependencies
* Update the example project

## [0.1.0] - March 15, 2020

* Updated README file
* Updated rx_bloc dependencies
* Added UI Integration tests using Flutter Driver
* Added Unit Tests using the rx_bloc_test package

## [0.0.1] - Jan 16, 2020

* Initial release.
