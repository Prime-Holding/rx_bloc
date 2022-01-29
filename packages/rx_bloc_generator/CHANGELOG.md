## [5.1.1] - December 24, 2021
* Update dependencies 

## [5.1.0] - September 24, 2021
* Support Flutter `2.5`
* Update `rxdart` to use version `0.27.2`

## [5.0.1] - September 22, 2021
* Allow generating behaviour subject events without a seed

## [5.0.0] - May 21, 2021
* Support Flutter `2.2`
* Update `rxdart` to use version `0.27.0`

## [4.0.0] - April 28, 2021
* Upgraded (`null-safety`) dependencies

## [3.0.2] - April 05, 2021
* Added type to the BehaviorSubject with seed value, Example: `final _$reloadEvent = BehaviorSubject<bool>.seeded(null);`

## [3.0.1] - March 22, 2021
* Dependencies clean-up

## [3.0.0] - March 10, 2021
* Migrated to Flutter `2.0` and Dart `2.12` (null-safety).

## [2.0.0] - February 12, 2021
* Support events with optional parameter and enum default value
* Support events with named parameter and a default value
* Support events with positional and optional parameters at the same time
* Support events with multiple optional parameters with default values
* Support events with multiple named parameters with default values
* Support any seed params
* Version >=2.0.0 introduces a change into generating the constructor parameters of the event arguments class.
```dart
 // <2.0.0 the event argument class constructor parameters are always named.
  @RxBlocEvent(type:RxBlocEventType.behaviour, seed: _SubtractEventArgs(a:0, b:0))
  void subtract(int a, int b);
 // =>2.0.0 the event argument class constructor parameters are the same how they are defined for the event method.
   @RxBlocEvent(type:RxBlocEventType.behaviour, seed: _SubtractEventArgs(0, 0))
  void subtract(int a, int b);
  ```
 * Upgraded the dependencies to the latest versions fo `analyzer`, `build`, `rx_bloc`, and `dart_style`
 * Stability improvements
 * Improved error handling

## [1.0.1] - December 08, 2020
* Stability improvements

## [1.0.0] - December 02, 2020
* Consolidated rx_bloc ecosystem [in one repository](https://github.com/Prime-Holding/rx_bloc)
* Removed flutter dependency
* Applied strict static code analysis
* Fixes and improvements

## [0.2.1] - May 5, 2020
* Updated package dependencies
* Reorganized package

## [0.2.0] - May 5, 2020

* Improved error handling and displaying:
  Error messages are logged in the console with an [ERROR] tag and a red color for easier noticing
* Events (and seeds using the @RxBlocEvent annotation) support multiple parameters

## [0.1.3] - April 7, 2020

* Updated package dependencies

## [0.1.2] - March 19, 2020

* Fixed generation of `part of` 
* Updated `rx_bloc` package to `0.2.0`

## [0.1.1] - March 16, 2020

* Fixed conflicting outputs with other builders

## [0.1.0] - March 14, 2020

* Implemented @RxBlocEvent annotation
* Generated event subjects and mappers are now private to the BloC
* Updated README file
* Updated rx_bloc dependency

## [0.0.1] - Jan 16, 2020

* Initial release
