{{> licence.dart }}

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_profile/blocs/profile_bloc.dart';

import 'profile_mock.mocks.dart';

@GenerateMocks([ProfileBlocStates, ProfileBlocEvents, ProfileBlocType])
ProfileBlocType profileMockFactory({
  Result<bool>? areNotificationsEnabled,
  bool? isLoading,
  ErrorModel? errors,
}) {
  final blocMock = MockProfileBlocType();
  final eventsMock = MockProfileBlocEvents();
  final statesMock = MockProfileBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final areNotificationsEnabledState = (areNotificationsEnabled != null
          ? Stream.value(areNotificationsEnabled)
          : const Stream<Result<bool>>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  when(statesMock.areNotificationsEnabled)
      .thenAnswer((_) => areNotificationsEnabledState);
  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);

  return blocMock;
}
