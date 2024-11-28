import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/lib_pin_code/bloc/update_and_verify_pin_bloc.dart';

import 'update_and_verify_pin_bloc_mock.mocks.dart';

@GenerateMocks([
  UpdateAndVerifyPinBlocType,
  UpdateAndVerifyPinBlocEvents,
  UpdateAndVerifyPinBlocStates
])
UpdateAndVerifyPinBlocType updateAndVerifyPinMockFactory() {
  final blocMock = MockUpdateAndVerifyPinBlocType();
  final eventsMock = MockUpdateAndVerifyPinBlocEvents();
  final statesMock = MockUpdateAndVerifyPinBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final emptyState = Stream.value(null).publishReplay(maxSize: 1)..connect();

  when(statesMock.deleteStoredPinData).thenAnswer((_) => emptyState);
  when(statesMock.deletedData).thenAnswer((_) => emptyState);
  when(statesMock.deleteStoredPinData).thenAnswer((_) => emptyState);
  when(statesMock.isPinUpdated).thenAnswer((_) => emptyState.skip(1).publish());
  when(statesMock.sessionValue).thenAnswer((_) =>
      Stream.value(SessionState.stopListening).publishReplay(maxSize: 1)
        ..connect());

  return blocMock;
}
