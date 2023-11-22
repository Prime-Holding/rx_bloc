import 'package:firebase_auth/firebase_auth.dart';

import '../data_sources/remote/reminders_firebase_data_source.dart';

/// Firebase Repository handling all the user related operations
class FirebaseRepository {
  /// Constructor taking in a [RemindersFirebaseDataSource] as a data source
  FirebaseRepository({required RemindersFirebaseDataSource dataSource})
      : _dataSource = dataSource;

  final RemindersFirebaseDataSource _dataSource;

  /// Performs a user login (anonymous or through Facebook) and returns whether
  /// the operation was successful or not
  Future<bool> logIn(bool anonymous) => _dataSource.logIn(anonymous);

  /// Logs out the current user, clearing the session
  Future<void> logOut() => _dataSource.logOut();

  /// Returns the currently logged-in user, if any
  Stream<User?> get currentUser => _dataSource.currentUser;

  /// Checks if the user is logged in and returns true if so
  Future<bool> isUserLoggedIn() => _dataSource.isUserLoggedIn();
}
