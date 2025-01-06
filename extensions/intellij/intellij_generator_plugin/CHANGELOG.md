<!-- Keep a Changelog guide -> https://keepachangelog.com -->

# RxBloc IntelliJ Plugin Changelog

## [4.0.0] - Unreleased

### Changed

- Migrate to [IntelliJ Platform Gradle Plugin 2.0](https://blog.jetbrains.com/platform/2024/07/intellij-platform-gradle-plugin-2-0/).
- Upgrade Gradle Wrapper to `8.10.2`
- Update `platformVersion` to `2023.3.8`
- Change since build to `233` (2023.3)

## [3.1.0] - 2024-11-28

### Added

- Added the option to choose between the `golden_toolkit` and `alchemist` packages when creating golden tests.


## [3.0.4] - 2024-07-11

### Changed

- Replaced deprecated classes from external libraries with their updated counterparts to ensure compatibility and improve performance.

## [3.0.3] -  2023-10-11

### Fixed

- Incompatibility issues with Android Studio Giraffe

## [3.0.2] - 2023-04-20

### Changed

- Separate state mock initialization.

## [3.0.1] - 2023-03-20

### Fixed

- Imports for features created in sub-folder.

## [3.0.0] - 2023-02-28

### Added

- Detect user-selected folder/item so the bootstrap (RxBloc Tests) menu item is optionally visible.
- Skip the feature/lib selection when features are selected and directly generate tests.
- Added a combo box in the "Create Feature" dialog for choosing Routing Solution:
    - Go Route
    - Auto Route
    - None
- Replace extensions with service when checkbox is On.

### Changed

- Improved imports in the generated tests.

### Removed

- Removed the null safety checkbox.

## [2.1.0] - 2022-11-29

### Added

- Allow scanning `lib/src` folder for features and libs.

### Changed

- Improved imports in the generated tests.

### Fixed

- Fixed auto-wrap freeze.

## [2.0.0] - 2022-10-25

### Added

- Bootstrap Test Generator in the project menu that outputs:
    - Bootstrapped unit test for the bloc
    - Factory of the page associated with the bloc
    - Code for mocking the bloc states
    - Template for creating golden tests with the most common use cases:
        - empty result
        - error
        - loading
        - success

## [1.5.0] - 2022-09-19

### Changed

- Updated DI Dependencies to not be a singleton.
- Improvement to the "Wrap With Quick Action Support" to analyze, filter, and display a choose BloC states dialog based on the file names and path by the convention:
    - feature_xx
        - bloc / xx_bloc.dart
        - di
        - views / xx_page.dart

### Added

- Filters to display BloC states:
    - **RxResultBuilder** - filters states with `Result`
    - **RxPaginatedBuilder** - filters states with `PaginatedList`
    - **RxTextFormFieldBuilder** - filters states that are `string`

## [1.4.0] - 2021-07-08

### Added

- Introduce "New -> RxBloc List"
- Wrap With Quick Action Support (RxBlocBuilder, RxResultBuilder, RxPaginatedBuilder, RxBlocListener, RxFormFieldBuilder, RxTextFormFieldBuilder).

## [1.3.0] - 2021-06-17

### Added

- Option for creating an entire feature that includes bloc, page and dependency injection

## [1.2.0] - 2021-03-22

### Added

- Option for creating Null Safety BloC classes

## [1.1.0] - 2021-03-02

### Added

- Option for creating BloC extensions

## [1.0.0] - 2021-02-22

### Added

- Initial release