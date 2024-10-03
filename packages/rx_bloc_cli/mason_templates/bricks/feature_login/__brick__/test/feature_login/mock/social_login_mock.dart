import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/lib_social_logins/blocs/social_login_bloc.dart';

import 'social_login_mock.mocks.dart';

@GenerateMocks([SocialLoginBlocStates, SocialLoginBlocEvents, SocialLoginBlocType])
SocialLoginBlocType socialLoginMockFactory({
  bool? loggedIn,
  bool? isLoading,
  ErrorModel? errors,
}) {
  final blocMock = MockSocialLoginBlocType();
  final eventsMock = MockSocialLoginBlocEvents();
  final statesMock = MockSocialLoginBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final loggedInState = (loggedIn != null
          ? Stream.value(loggedIn)
          : const Stream<bool>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  when(statesMock.loggedIn).thenAnswer((_) => loggedInState);
  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);

  return blocMock;
}
