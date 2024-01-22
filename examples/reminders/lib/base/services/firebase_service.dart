import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/firebase_repository.dart';

/// Firebase service class handling all user related operations
class FirebaseService {
  /// Firebase service constructor taking in a [FirebaseRepository]
  FirebaseService(this._repository);

  final FirebaseRepository _repository;

  /// Performs a user login (anonymous or through Facebook) and returns whether
  /// the operation was successful or not
  Future<bool> logIn(bool anonymous) => _repository.logIn(anonymous);

  /// Logs out the current user, if any
  Future<bool> logOut() async {
    await _repository.logOut();
    return true;
  }

  /// Returns the currently logged-in user or null if none
  Stream<User?> get currentUser => _repository.currentUser;

  /// Checks if the user is logged in and returns true if so
  Future<bool> isUserLoggedIn() => _repository.isUserLoggedIn();
}
