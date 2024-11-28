import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reminders/base/common_blocs/coordinator_bloc.dart';

import 'coordinator_mock.mocks.dart';

@GenerateMocks([
  CoordinatorStates,
  CoordinatorEvents,
  CoordinatorBlocType,
])
CoordinatorBlocType coordinatorMockFactory() {
  final blocMock = MockCoordinatorBlocType();
  final eventsMock = MockCoordinatorEvents();
  final statesMock = MockCoordinatorStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  return blocMock;
}
