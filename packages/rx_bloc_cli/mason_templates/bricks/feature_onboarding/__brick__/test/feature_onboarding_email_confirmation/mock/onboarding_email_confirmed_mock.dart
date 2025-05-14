{{> licence.dart }}

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/feature_onboarding_email_confirmation/blocs/onboarding_email_confirmed_bloc.dart';

import 'onboarding_email_confirmed_mock.mocks.dart';

@GenerateMocks([
  OnboardingEmailConfirmedBlocStates,
  OnboardingEmailConfirmedBlocEvents,
  OnboardingEmailConfirmedBlocType
])
OnboardingEmailConfirmedBlocType onboardingEmailConfirmedMockFactory({
  bool? isLoading,
  ErrorModel? errors,
  UserModel? data,
}) {
  final blocMock = MockOnboardingEmailConfirmedBlocType();
  final eventsMock = MockOnboardingEmailConfirmedBlocEvents();
  final statesMock = MockOnboardingEmailConfirmedBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  final dataState = (data != null
          ? Stream.value(data)
          : const Stream<UserModel>.empty())
      .publishReplay(maxSize: 1)
    ..connect();
  final onRoutingState = const Stream<void>.empty().publishReplay(maxSize: 1)
    ..connect();

  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);
  when(statesMock.data).thenAnswer((_) => dataState);
  when(statesMock.onRouting).thenAnswer((_) => onRoutingState);

  return blocMock;
}
