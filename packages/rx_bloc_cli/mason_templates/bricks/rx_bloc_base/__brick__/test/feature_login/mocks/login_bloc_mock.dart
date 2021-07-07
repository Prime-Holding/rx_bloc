import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/feature_login/blocs/login_bloc.dart';

import '../../helpers/stubs.dart';
import 'login_bloc_mock.mocks.dart';

@GenerateMocks([
  LoginBlocEvents,
  LoginBlocStates,
  LoginBlocType,
])
LoginBlocType loginBlocMockFactory({
  String? username,
  String? password,
  bool? loggedIn,
  bool? showErrors,
  String? error,
  bool? isLoading,
}) {
  final loginBloc = MockLoginBlocType();
  final eventsMock = MockLoginBlocEvents();
  final statesMock = MockLoginBlocStates();

  when(loginBloc.events).thenReturn(eventsMock);
  when(loginBloc.states).thenReturn(statesMock);

  when(statesMock.username).thenAnswer(
    (_) => username != null ? Stream.value(username) : const Stream.empty(),
  );

  when(statesMock.password).thenAnswer(
    (_) => password != null ? Stream.value(password) : const Stream.empty(),
  );

  when(statesMock.loggedIn).thenAnswer(
    (_) => loggedIn != null ? Stream.value(loggedIn) : const Stream.empty(),
  );

  when(statesMock.showErrors).thenAnswer(
    (_) => showErrors != null ? Stream.value(showErrors) : const Stream.empty(),
  );

  when(statesMock.errors).thenAnswer(
    (_) => error != null ? Stream.value(error) : const Stream.empty(),
  );

  when(statesMock.isLoading).thenAnswer(
    (_) => isLoading != null ? Stream.value(isLoading) : const Stream.empty(),
  );

  return loginBloc;
}
