{{> licence.dart }}

// ignore_for_file: lines_longer_than_80_chars

// Here lie all your app constants

/// The [isInTestMode] in these files is used to exclude the dependencies
/// from smart widgets for golden tests.
///
/// Since we don't want to add dependency on [universal_io/io.dart],
/// we check if [dart.library.io] is available to determine
/// if we are running test or other environment.
///
/// It should use it as follows:
///
/// import '../../base/app/config/app_constants.dart';
///
//// class AppTodoListBulkEditPopupMenuButtonWithDependencies {
///     @override
///     Widget build(BuildContext context) {
///         final current =  TodoManagementPage();
///
///         if(isInTestMode) {
///             return current;
///         }
///
///         return MultiProvider(
///             providers: [
///               ..._services,
///               ..._blocs,
///            ],
///            child: current,
///         );
///   }
/// }
///
/// IMPORTANT: you should import [isInTestMode] from [app_constants.dart]
///

export 'is_in_test_mode_io_not_available.dart' if (dart.library.io) 'is_in_test_mode_io_available.dart' if (dart.library.html) 'is_in_test_mode_io_not_available.dart';

/// Vapid Key is required in order to for FCM to run on web properly
/// https://github.com/FirebaseExtended/flutterfire/blob/4c9b5d28de9eeb5ce76c856fbd0c7b3ec8615e45/docs/messaging/usage.mdx#web-tokens
const String webVapidKey = '';
