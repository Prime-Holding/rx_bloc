## [5.0.2]
* Fixes and improvements

## [5.0.1]
* Support Flutter `3.19`
* Export ErrorWithTag model outside of rx_bloc
* Update `meta` to use version `1.11.0`

## [5.0.0]
* Dart `3.0` Required
* **Breaking changes**
- Converted `Result` to *sealed class*
* Update `rxdart` to use version `0.27.7`
* Updated dependencies

## [4.0.1]
- Documentation improvements

## [4.0.0]
* **Breaking changes**
- Removed `disposedBy` extension method for the `StreamSubscription` extension. Use the `addTo` method provided by the rxdart library instead.

## [3.3.1]
- Add equality check [support](https://github.com/Prime-Holding/rx_bloc/pull/247) for maps with nested objects on the [Result](https://pub.dev/documentation/rx_bloc/latest/rx_bloc/Result-class.html) class, thanks to [pangievich](https://github.com/PankovSerge)

## [3.3.0]
- Added `Stream<T>` extensions: `mapToResult`, `withLatestFromResult`
- Added `Stream<Result<T>>` extensions: `mapResult`, `asyncMapResult`
- Added `Result<T>` extensions: `mapResult`, `asyncMapResult`

## [3.2.1]
* Added a [presentation](https://youtu.be/nVX4AzeuVu8) to the README file
* Fixed memory leak caused by a not closed subscription in the LoadingBloc
* Upgraded to rxdart ^0.27.3

## [3.2.0]
* Support Flutter `2.5`
* Update `rxdart` to use version `0.27.2`

## [3.1.2]
* Allow the bind extension to be used with both Publish and Behaviour subjects

## [3.1.1]
* Added video tutorials and a github search sample to the `README.md`

## [3.1.0]
* Added an optional param `tag` to (Future/Stream).asResultStream(tag: 'someTag'). 
  * This will help to distinguish the action that has been triggered a particular async call. Check the [flutter_rx_bloc example](https://pub.dev/packages/flutter_rx_bloc/example) for more details.
* Added utility (extension) methods
  * `Stream<ResultError<T>>`.`mapToException()`
  * `Stream<ResultError<T>>`.`mapToErrorWithTag()`
  * `Stream<Result<T>>`.`isLoadingWithTag()`
* Added new states and methods to RxBlocBase
    * `RxBlocBase`.`errorWithTagState` 
    * `RxBlocBase`.`loadingWithTagState`
    * `RxBlocBase`.`loadingForTagState('someTag')`

## [3.0.0]
* Support Flutter `2.2`
* Update `rxdart` to use version `0.27.0`

## [2.0.2]
* `Result` equatable improvements
* Stability improvements
* Increased code coverage
* Documentation updates

## [2.0.0]
* Migrated to Flutter `2.0` and Dart `2.12` (null-safety).

## [1.2.3]
* Documentation improvements
 
## [1.2.2]
* Stability improvements

## [1.2.1]
* Stability improvements

## [1.2.0]
* Fixed side effects in setStateHandler/setErrorStateHandler/setLoadingHandler
* Removed rx_bloc/extensions library as this is now part of rx_bloc/rx_bloc
* Increased code coverage

## [1.1.1]
* Upgraded to rxdart ^0.25.0
* Upgraded to meta: ^1.2.4

## [1.0.4]
* Consolidated rx_bloc ecosystem [in one repository](https://github.com/Prime-Holding/rx_bloc)
* Applied strict static code analysis
* Improved equability of the `ResultSuccess` class
* Improved example
* Documentation improvements

## [1.0.1]
* Upgraded to last stable SDK

## [1.0.0]
* Upgraded to last stable Flutter/Dart
* Reorganized as a [library package](https://dart.dev/guides/libraries/create-library-packages#organizing-a-library-package)
* Implemented Stream extensions
  * setErrorStateHandler()
  * setLoadingStateHandler()
* Renamed parameter `shareStream` to `shareReplay` of setResultStateHandler() 

## [0.3.1]
* Upgraded to last stable Flutter/Dart
* Upgraded to last stable rxdart
* Added an example
* Stability improvements

## [0.3.0]

* Added `asResultStream()` extension method to the Stream
* Fixed behaviour of `setResultStateHandler` when `shareStream` parameter is `true`.

## [0.2.0]

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

## [0.1.0]

* Removed const annotations @rxBloc and @rxBlocIgnoreState
* Removed flutter as dependency in favour of the meta package
* Added unit tests
* Updated README file

## [0.0.1]

* Initial release
