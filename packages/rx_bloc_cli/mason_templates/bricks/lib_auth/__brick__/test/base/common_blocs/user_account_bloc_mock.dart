import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/lib_auth/blocs/user_account_bloc.dart';

import 'user_account_bloc_mock.mocks.dart';

@GenerateMocks([
  UserAccountBlocEvents,
  UserAccountBlocStates,
  UserAccountBlocType,
])
UserAccountBlocType userAccountBlocMockFactory({
  required bool loggedIn,
  ErrorModel? error,
  bool? isLoading,
  UserModel? user,
}) {
  final userAccountBloc = MockUserAccountBlocType();
  final eventsMock = MockUserAccountBlocEvents();
  final statesMock = MockUserAccountBlocStates();

  when(userAccountBloc.events).thenReturn(eventsMock);
  when(userAccountBloc.states).thenReturn(statesMock);

  final loadingState = (isLoading != null
          ? Stream.value(isLoading)
          : const Stream<bool>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final loggedInState = Stream.value(loggedIn).publishReplay(maxSize: 1)
    ..connect();

  when(statesMock.loggedIn).thenAnswer((_) => loggedInState);

  when(statesMock.isLoading).thenAnswer((_) => loadingState);

  when(statesMock.currentUser).thenAnswer(
    (_) => Stream.value(user).publishReplay(maxSize: 1),
  );

  when(statesMock.errors).thenAnswer(
    (_) => error != null ? Stream.value(error) : const Stream.empty(),
  );

  return userAccountBloc;
}
