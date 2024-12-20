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
  Result<bool>? syncNotificationsStatus,
  bool? isLoading,
  ErrorModel? errors, {{#enable_pin_code}}
  bool? canCheckBiometrics, {{/enable_pin_code}}
}) {
  final blocMock = MockProfileBlocType();
  final eventsMock = MockProfileBlocEvents();
  final statesMock = MockProfileBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final areNotificationsEnabledState = areNotificationsEnabled != null
      ? Stream.value(areNotificationsEnabled).shareReplay(maxSize: 1)
      : const Stream<Result<bool>>.empty();

  final syncNotificationsStatusState = (syncNotificationsStatus != null
          ? Stream.value(syncNotificationsStatus)
          : const Stream<Result<bool>>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();
  {{#enable_pin_code}}
  final canCheckBiometricsState = canCheckBiometrics != null
      ? Stream.value(canCheckBiometrics).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  when(statesMock.canCheckBiometrics).thenAnswer((_) => canCheckBiometricsState); {{/enable_pin_code}}
  when(statesMock.areNotificationsEnabled)
      .thenAnswer((_) => areNotificationsEnabledState);
  when(statesMock.syncNotificationsStatus)
      .thenAnswer((_) => syncNotificationsStatusState);
  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);

  return blocMock;
}
