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

Future<bool> logIn() =>
    _repository.logIn();
}
