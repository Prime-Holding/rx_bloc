import 'package:mockito/annotations.dart';
import 'package:reminders/base/repositories/firebase_repository.dart';
import 'package:reminders/base/repositories/reminders_repository.dart';

import 'repository_mocks.mocks.dart';

@GenerateMocks([
  RemindersRepository,
  FirebaseRepository,
])
MockRemindersRepository createRemindersRepositoryMock() =>
    MockRemindersRepository();
MockFirebaseRepository createFirebaseRepositoryMock() =>
    MockFirebaseRepository();
