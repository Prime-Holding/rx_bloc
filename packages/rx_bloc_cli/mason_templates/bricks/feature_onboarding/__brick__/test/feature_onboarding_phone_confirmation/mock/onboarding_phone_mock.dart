{{> licence.dart }}

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/country_code_model.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/feature_onboarding_phone_confirm/blocs/onboarding_phone_bloc.dart';

import 'onboarding_phone_mock.mocks.dart';

@GenerateMocks([
  OnboardingPhoneBlocStates,
  OnboardingPhoneBlocEvents,
  OnboardingPhoneBlocType
])
OnboardingPhoneBlocType onboardingPhoneMockFactory({
  bool? isLoading,
  UserModel? phoneSubmitted,
  CountryCodeModel? countryCode,
  String? phoneNumber,
  ErrorModel? errors,
  bool? showErrors,
}) {
  final blocMock = MockOnboardingPhoneBlocType();
  final eventsMock = MockOnboardingPhoneBlocEvents();
  final statesMock = MockOnboardingPhoneBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final phoneSubmittedState = (phoneSubmitted != null
          ? Stream.value(phoneSubmitted)
          : const Stream<UserModel>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final countryCodeState = countryCode != null
      ? Stream.value(countryCode).shareReplay(maxSize: 1)
      : const Stream<CountryCodeModel?>.empty();

  final phoneNumberState = phoneNumber != null
      ? Stream.value(phoneNumber).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  final showErrorsState = showErrors != null
      ? Stream.value(showErrors).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.phoneSubmitted).thenAnswer((_) => phoneSubmittedState);
  when(statesMock.countryCode).thenAnswer((_) => countryCodeState);
  when(statesMock.phoneNumber).thenAnswer((_) => phoneNumberState);
  when(statesMock.errors).thenAnswer((_) => errorsState);
  when(statesMock.showErrors).thenAnswer((_) => showErrorsState);

  return blocMock;
}
