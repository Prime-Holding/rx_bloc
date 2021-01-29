## [1.2.1] - December 24, 2020
* Stability improvements

## [1.2.0] - December 24, 2020
* Fixed side effects in setStateHandler/setErrorStateHandler/setLoadingHandler
* Removed rx_bloc/extensions library as this is now part of rx_bloc/rx_bloc
* Increased code coverage

## [1.1.1] - December 08, 2020
* Upgraded to rx_dart ^0.25.0
* Upgraded to meta: ^1.2.4

## [1.0.4] - December 02, 2020
* Consolidated rx_bloc ecosystem [in one repository](https://github.com/Prime-Holding/rx_bloc)
* Applied strict static code analysis
* Improved equability of the `ResultSuccess` class
* Improved example
* Documentation improvements

## [1.0.1] - August 21, 2020
* Upgraded to last stable SDK

## [1.0.0] - August 20, 2020
* Upgraded to last stable Flutter/Dart
* Reorganized as a [library package](https://dart.dev/guides/libraries/create-library-packages#organizing-a-library-package)
* Implemented Stream extensions
  * setErrorStateHandler()
  * setLoadingStateHandler()
* Renamed parameter `shareStream` to `shareReplay` of setResultStateHandler() 

## [0.3.1] - April 29, 2020
* Upgraded to last stable Flutter/Dart
* Upgraded to last stable RxDart
* Added an example
* Stability improvements

## [0.3.0] - April 5, 2020

* Added `asResultStream()` extension method to the Stream
* Fixed behaviour of `setResultStateHandler` when `shareStream` parameter is `true`.

## [0.2.0] - March 18, 2020

* **Breaking changes**
  * Renamed methods in RxBlocBase class:
    * `registerRequest` -> `setResultStateHandler`
    * `registerRequestToLoading` -> `setLoadingStateHandler`
    * `registerRequestToErrors` -> `setErrorStateHandler`
  * Renamed properties in RxBlocBase class:
    * `requestsLoadingState` -> `loadingState`
    * `requestsExceptions` -> `errorState`
  * Renamed method in Stream extension:
    * `registerRequest` -> `setResultStateHandler`
* Added an optional named parameter `shareStream` to `setResultStateHandler` methods. It has default value `true`. If it is `true` the stream will be converted to broadcast one before registering it to errors and loading. 

## [0.1.0] - March 14, 2020

* Removed const annotations @rxBloc and @rxBlocIgnoreState
* Removed flutter as dependency in favour of the meta package
* Added unit tests
* Updated README file

## [0.0.1] - Jan 16, 2020

* Initial release
