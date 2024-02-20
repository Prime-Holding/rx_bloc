## [4.0.1] February 20, 2023
* Fix paginated list scroll events call

## [4.0.0] July 12, 2023
* Dart `3.0` Required
* Updated `flutter_rx_bloc` to use version `6.0.0`
* Updated `rx_bloc` to use version `5.0.0`

## [3.2.1] January 28, 2022
* Update the example project
* Updated `rx_bloc` to use version `4.0.0`

## [3.2.0] November 1, 2022
* Updated `flutter_rx_bloc` to use version `5.0.0`
* Updated `rx_bloc` to use version `3.3.0`
* Added `Identifiable` interface for handling inter-feature communication
* Added `List<T extends Identifiable>` extensions: `containsIdentifiable`, `removeIdentifiable`, `mergeWith`
* Added `Stream<T extends Identifiable>` extensions: `withLatestFromIdentifiableList`
* Added `ManagedList<T>` class
* Added `Stream<ManagedList<E extends Identifiable>>` extensions: `mapToList`

**Braking changes**:

- Removed `IdentifiablePair<E extends Identifiable>` class
- Removed `Stream<IdentifiablePair<E extends Identifiable>>` extensions: `withLatestFromIdentifiablePairList`

## [3.2.0-dev.2] June 7, 2022
* Updated `flutter_rx_bloc` to use version `5.0.0`
* Updated `rx_bloc` to use version `3.3.0`
- Added `IdentifiablePair<E extends Identifiable>` class
- Added `Stream<IdentifiablePair<E extends Identifiable>>` extensions: `withLatestFromIdentifiablePairList`
- Removed parameter `identifiableInList` from `operationCallback` in `Stream<T extends Identifiable>` extension: `withLatestFromIdentifiableList`

## [3.2.0-dev.1] January 30, 2022
- Added `Identifiable` interface for handling inter-feature communication
- Added `List<T extends Identifiable>` extensions: `ids`, `containsIdentifiable`, `removeIdentifiable`, `mergeWith`
- Added `Stream<T extends Identifiable>` extensions: `mapCreatedWithLatestFrom`, `mapUpdatedWithLatestFrom`, `mapDeletedWithLatestFrom`, `withLatestFromIdentifiableList`
- Added `ManagedList<T>` class

## [3.1.0] - September 24, 2021
* Support Flutter `2.5`
* Updated `rxdart` to use version `0.27.2`
* Updated `flutter_rx_bloc` to use version `4.0.0`
* Updated `rx_bloc` to use version `3.2.0`

## [3.0.2] - September 17, 2021
* Call onBottomScrolled only if the [enableOnBottomScrolledCallback] is set to true and the fetched items are less than the total count.

## [3.0.1] - July 21, 2021
* `PaginatedList`.`reset(hard: true)` now triggers `RxPaginatedBuilder`.`buildLoading`

## [3.0.0] - May 21, 2021
* Support Flutter `2.2`
* Update `rxdart` to use version `0.27.0`

## [2.0.0] - March 25, 2021
* **BREAKING** - removed the `builder` method in favour of `buildSuccess`, `buildError` and `buildLoading` methods
* feat! - added an optional param `hard` to the `PaginatedList`.`reset()` method

## [1.0.1] - March 23, 2021
* Documentation fixes

## [1.0.0] - March 23, 2021
* Initial release

