import 'package:firebase_auth/firebase_auth.dart';

import '../data_sources/remote/reminders_firebase_data_source.dart';

class FirebaseRepository {
  FirebaseRepository({required RemindersFirebaseDataSource dataSource})
      : _dataSource = dataSource;

  final RemindersFirebaseDataSource _dataSource;

  Future<bool> logIn(bool anonymous) => _dataSource.logIn(anonymous);

  Future<void> logOut() => _dataSource.logOut();

  Stream<User?> get currentUser => _dataSource.currentUser;

  Future<bool> isUserLoggedIn() => _dataSource.isUserLoggedIn();
}
