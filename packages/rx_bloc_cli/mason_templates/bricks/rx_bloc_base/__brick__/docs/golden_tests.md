### Smart Widgets dependencies for Golden Tests

In golden tests we want to mock the BLoCs to be able to test all UI states. By using smart widgets that manage their dependencies, golden tests could fail. To fix this issue we need to build the smart widgets without injecting the required components during the test. This is why we added `isInTestMode` in `app_constants.dart`.

To use it in custom widgets with their own dependency injection you can follow this example:
```
import '../../base/app/config/app_constants.dart';

...

class AppTodoListBulkEditPopupMenuButtonWithDependencies {
    @override
    Widget build(BuildContext context) {
        final current = TodoManagementPage();
        
        if(isInTestMode) {
            return current;
        }
        
        return MultiProvider(
            providers: [
                ..._services,
                ..._blocs,
            ],
            child: current,
        );
    }
}
```
> [!CAUTION]
> You should import `isInTestMode` from `app_constants.dart`.
> Since we don't want to add a dependency on `universal_io/io.dart` (avoiding additional maintenance cost), we check if `dart.library.io` is available to determine if we are running in a test environment or not.

*app_constants.dart*
```
export 'is_in_test_mode_io_not_available.dart' if (dart.library.io) 'is_in_test_mode_io_available.dart' if (dart.library.html) 'is_in_test_mode_io_not_available.dart';
```
*is_in_test_mode_io_available.dart*
```
import 'dart:io';

bool isInTestMode = Platform.environment.containsKey('FLUTTER_TEST');
```

*is_in_test_mode_io_not_available.dart*
```
const bool isInTestMode = false;
```