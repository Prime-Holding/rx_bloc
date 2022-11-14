import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/firebase_repository.dart';

class FirebaseService {
  FirebaseService(this._repository);

  final FirebaseRepository _repository;

  Future<void> updateCountersInDataSource({
    required int completeCount,
    required int incompleteCount,
  }) =>
      _repository.updateCountersInDataSource(
        completeCount: completeCount,
        incompleteCount: incompleteCount,
      );

  Future<bool> logIn(bool anonymous) => _repository.logIn(anonymous);

  Future<void> logOut() => _repository.logOut();

  Stream<User?> get currentUser => _repository.currentUser;

  Future<bool> isUserLoggedIn() => _repository.isUserLoggedIn();
}