import '../data_sources/remote/reminders_firebase_data_source.dart';

class FirebaseRepository{
  FirebaseRepository({required RemindersFirebaseDataSource dataSource}):
      _dataSource = dataSource;

  final RemindersFirebaseDataSource _dataSource;

  Future<void> updateCountersInDataSource({
    required int completeCount,
    required int incompleteCount,
  }) =>_dataSource.updateCountersInDataSource(completeCount:completeCount,
      incompleteCount:incompleteCount);

  Future<bool> logIn() =>
      _dataSource.logIn();
}