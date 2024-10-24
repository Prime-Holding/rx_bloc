import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';

import 'coordinator_bloc_mock.mocks.dart';

@GenerateMocks([
  CoordinatorBlocType,
])
CoordinatorBlocType coordinatorBlocMockFactory(
    {CoordinatorEvents? events, CoordinatorStates? states}) {
  final coordinatorBloc = MockCoordinatorBlocType();

  when(coordinatorBloc.events)
      .thenReturn(events ?? coordinatorEventsMockFactory());

  when(coordinatorBloc.states)
      .thenReturn(states ?? coordinatorStatesMockFactory());

  return coordinatorBloc;
}

@GenerateMocks([
  CoordinatorEvents,
])
CoordinatorEvents coordinatorEventsMockFactory() => MockCoordinatorEvents();

@GenerateMocks([
  CoordinatorStates,
])
CoordinatorStates coordinatorStatesMockFactory() => MockCoordinatorStates();
