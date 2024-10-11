import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testapp/lib_pin_code/bloc/create_pin_bloc.dart';

import 'create_pin_bloc_mock.mocks.dart';

@GenerateMocks([CreatePinBlocType, CreatePinBlocEvents, CreatePinBlocStates])
CreatePinBlocType createPinMockFactory({
  bool? isPinCreated,
  bool? deleteStoredPinData,
}) {
  final blocMock = MockCreatePinBlocType();
  final eventsMock = MockCreatePinBlocEvents();
  final statesMock = MockCreatePinBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final isPinCreatedState = (isPinCreated != null
      ? Stream.value(isPinCreated)
      : const Stream<bool>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final deleteStoredPinDataState = (deleteStoredPinData != null
      ? Stream.value(deleteStoredPinData)
      : const Stream<bool>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  when(statesMock.deleteStoredPinData).thenAnswer(
        (_) => deleteStoredPinDataState,
  );

  when(statesMock.isPinCreated).thenAnswer((_) => isPinCreatedState);

  return blocMock;
}
