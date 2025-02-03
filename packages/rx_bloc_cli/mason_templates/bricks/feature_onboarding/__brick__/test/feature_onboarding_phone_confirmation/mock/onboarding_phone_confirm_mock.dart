{{> licence.dart }}

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_onboarding_phone_confirm/blocs/onboarding_phone_confirm_bloc.dart';

import 'onboarding_phone_confirm_mock.mocks.dart';

@GenerateMocks([
  OnboardingPhoneConfirmBlocStates,
  OnboardingPhoneConfirmBlocEvents,
  OnboardingPhoneConfirmBlocType
])
OnboardingPhoneConfirmBlocType onboardingPhoneConfirmMockFactory({
  ErrorModel? errors,
}) {
  final blocMock = MockOnboardingPhoneConfirmBlocType();
  final eventsMock = MockOnboardingPhoneConfirmBlocEvents();
  final statesMock = MockOnboardingPhoneConfirmBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  final onRoutingState = const Stream<void>.empty().publishReplay(maxSize: 1)
    ..connect();

  when(statesMock.errors).thenAnswer((_) => errorsState);
  when(statesMock.onRouting).thenAnswer((_) => onRoutingState);

  return blocMock;
}
