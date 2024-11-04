import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_login/blocs/login_bloc.dart';

import 'login_mock.mocks.dart';

@GenerateMocks([LoginBlocStates, LoginBlocEvents, LoginBlocType])
LoginBlocType loginMockFactory({
  String? email,
  String? password,
  bool? loggedIn,
  bool? showErrors,
  bool? isLoading,
  ErrorModel? errors,
}) {
  final blocMock = MockLoginBlocType();
  final eventsMock = MockLoginBlocEvents();
  final statesMock = MockLoginBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final emailState = email != null
      ? Stream.value(email).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final passwordState = password != null
      ? Stream.value(password).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final loggedInState = (loggedIn != null
          ? Stream.value(loggedIn)
          : const Stream<bool>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final showErrorsState = showErrors != null
      ? Stream.value(showErrors).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  when(statesMock.email).thenAnswer((_) => emailState);
  when(statesMock.password).thenAnswer((_) => passwordState);
  when(statesMock.loggedIn).thenAnswer((_) => loggedInState);
  when(statesMock.showErrors).thenAnswer((_) => showErrorsState);
  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);

  return blocMock;
}
