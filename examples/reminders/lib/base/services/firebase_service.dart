import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/firebase_repository.dart';

class FirebaseService {
  FirebaseService(this._repository);

  final FirebaseRepository _repository;

  Future<bool> logIn(bool anonymous) => _repository.logIn(anonymous);

  Future<bool> logOut() async {
    await _repository.logOut();
    return true;
  }

  Stream<User?> get currentUser => _repository.currentUser;

  Future<bool> isUserLoggedIn() => _repository.isUserLoggedIn();
}
