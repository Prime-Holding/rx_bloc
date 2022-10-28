import 'package:github_search/base/common_blocs/user_account_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_account_bloc_mock.mocks.dart';

@GenerateMocks([
  UserAccountBlocEvents,
  UserAccountBlocStates,
  UserAccountBlocType,
])
UserAccountBlocType userAccountBlocMockFactory({
  required bool loggedIn,
  String? error,
  bool? isLoading,
}) {
  final userAccountBloc = MockUserAccountBlocType();
  final eventsMock = MockUserAccountBlocEvents();
  final statesMock = MockUserAccountBlocStates();

  when(userAccountBloc.events).thenReturn(eventsMock);
  when(userAccountBloc.states).thenReturn(statesMock);

  when(statesMock.loggedIn).thenAnswer(
    (_) => Stream.value(loggedIn),
  );

  when(statesMock.errors).thenAnswer(
    (_) => error != null ? Stream.value(error) : const Stream.empty(),
  );

  when(statesMock.isLoading).thenAnswer(
    (_) => isLoading != null ? Stream.value(isLoading) : const Stream.empty(),
  );

  return userAccountBloc;
}
