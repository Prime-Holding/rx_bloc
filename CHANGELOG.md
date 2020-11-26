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
