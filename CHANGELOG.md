## [0.2.1] - April 5, 2020
* Added `asResultStream()` extension method to the Stream

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
