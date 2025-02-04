{{> licence.dart }}

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_onboarding_email_confirmation/blocs/onboarding_email_confirmation_bloc.dart';

import 'onboarding_email_confirmation_mock.mocks.dart';

@GenerateMocks([
  OnboardingEmailConfirmationBlocStates,
  OnboardingEmailConfirmationBlocEvents,
  OnboardingEmailConfirmationBlocType
])
OnboardingEmailConfirmationBlocType onboardingEmailConfirmationMockFactory({
  bool? isLoading,
  ErrorModel? errors,
  String? email,
  bool? isSendNewLinkActive,
}) {
  final blocMock = MockOnboardingEmailConfirmationBlocType();
  final eventsMock = MockOnboardingEmailConfirmationBlocEvents();
  final statesMock = MockOnboardingEmailConfirmationBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  final openMailAppState = const Stream<void>.empty().publishReplay(maxSize: 1)
    ..connect();

  final emailState = email != null
      ? Stream.value(email).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final isSendNewLinkActiveState = isSendNewLinkActive != null
      ? Stream.value(isSendNewLinkActive).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);
  when(statesMock.openMailApp).thenAnswer((_) => openMailAppState);
  when(statesMock.email).thenAnswer((_) => emailState);
  when(statesMock.isSendNewLinkActive)
      .thenAnswer((_) => isSendNewLinkActiveState);

  return blocMock;
}
