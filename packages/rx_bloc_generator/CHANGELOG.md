## [7.3.0]
* Update `rx_bloc` to use version `5.1.0`
* * Update `collection` to use version `1.18.0`

## [7.2.2]
* Fix compiling issue caused by the analyzer version `6.5.0`

## [7.2.1]
* Support Flutter `3.22`

## [7.2.0]
* Support Flutter `3.19`

## [7.1.0]
* Support Flutter `3.16`
* Update dependencies and bump analyzer constraints to `>=6.0.0 <7.0.0` 

## [7.0.0]
* Dart `3.0` Required
* _[BREAKING CHANGE]_ Version >=7.0.0 introduces a change by generating named record instead of event arguments class.
```dart
 // <7.0.0 generates an event arguments class.
   @RxBlocEvent(type:RxBlocEventType.behaviour, seed: _SubtractEventArgs(0, 0))
  void subtract(int a, int b);

// >=7.0.0 generates a named record.
@RxBlocEvent(type:RxBlocEventType.behaviour, seed: (a: 0, b: 0))
void subtract(int a, int b);
  ```
* Update dependencies

## [6.0.2]
* Update dependencies

## [6.0.1]
* Drop upper version requirement for the analyzer dependency
* Update `rx_bloc` to use version `4.0.0`

## [6.0.0]
* Update dependencies
* _[BREAKING CHANGE]_ Update analyzer to `">=3.0.0 <=5.0.0"`
* Add support for generic blocs (Thanks [jld3103](https://github.com/jld3103) for the contribution)

## [5.1.1]
* Update dependencies 

## [5.1.0] 
* Support Flutter `2.5`
* Update `rxdart` to use version `0.27.2`

## [5.0.1] 
* Allow generating behaviour subject events without a seed

## [5.0.0] 
* Support Flutter `2.2`
* Update `rxdart` to use version `0.27.0`

## [4.0.0] 
* Upgraded (`null-safety`) dependencies

## [3.0.2] 
* Added type to the BehaviorSubject with seed value, Example: `final _$reloadEvent = BehaviorSubject<bool>.seeded(null);`

## [3.0.1] 
* Dependencies clean-up

## [3.0.0]
* Migrated to Flutter `2.0` and Dart `2.12` (null-safety).

## [2.0.0] 
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

## [1.0.1] 
* Stability improvements

## [1.0.0] 
* Consolidated rx_bloc ecosystem [in one repository](https://github.com/Prime-Holding/rx_bloc)
* Removed flutter dependency
* Applied strict static code analysis
* Fixes and improvements

## [0.2.1] 
* Updated package dependencies
* Reorganized package

## [0.2.0]

* Improved error handling and displaying:
  Error messages are logged in the console with an [ERROR] tag and a red color for easier noticing
* Events (and seeds using the @RxBlocEvent annotation) support multiple parameters

## [0.1.3] 

* Updated package dependencies

## [0.1.2]

* Fixed generation of `part of` 
* Updated `rx_bloc` package to `0.2.0`

## [0.1.1]

* Fixed conflicting outputs with other builders

## [0.1.0] 

* Implemented @RxBlocEvent annotation
* Generated event subjects and mappers are now private to the BloC
* Updated README file
* Updated rx_bloc dependency

## [0.0.1] 

* Initial release
