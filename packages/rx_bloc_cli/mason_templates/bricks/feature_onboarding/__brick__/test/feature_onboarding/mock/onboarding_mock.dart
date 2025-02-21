import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testapp/base/models/errors/error_model.dart';
import 'package:testapp/base/models/user_with_auth_token_model.dart';
import 'package:testapp/feature_onboarding/blocs/onboarding_bloc.dart';

import 'onboarding_mock.mocks.dart';

@GenerateMocks([OnboardingBlocStates, OnboardingBlocEvents, OnboardingBlocType])
OnboardingBlocType onboardingMockFactory({
  String? email,
  String? password,
  UserWithAuthTokenModel? registered,
  bool? showFieldErrors,
  bool? isLoading,
  ErrorModel? errors,
  ErrorModel? resumeOnboardingErrors,
}) {
  final blocMock = MockOnboardingBlocType();
  final eventsMock = MockOnboardingBlocEvents();
  final statesMock = MockOnboardingBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final emailState = email != null
      ? Stream.value(email).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final passwordState = password != null
      ? Stream.value(password).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final registeredState = (registered != null
          ? Stream.value(registered)
          : const Stream<UserWithAuthTokenModel>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final showFieldErrorsState = showFieldErrors != null
      ? Stream.value(showFieldErrors).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  final resumeOnboardingErrorsState = resumeOnboardingErrors != null
      ? Stream.value(resumeOnboardingErrors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  final onRoutingState = const Stream<void>.empty().publishReplay(maxSize: 1)
    ..connect();

  when(statesMock.email).thenAnswer((_) => emailState);
  when(statesMock.password).thenAnswer((_) => passwordState);
  when(statesMock.registered).thenAnswer((_) => registeredState);
  when(statesMock.showFieldErrors).thenAnswer((_) => showFieldErrorsState);
  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);
  when(statesMock.resumeOnboardingErrors)
      .thenAnswer((_) => resumeOnboardingErrorsState);
  when(statesMock.onRouting).thenAnswer((_) => onRoutingState);

  return blocMock;
}
