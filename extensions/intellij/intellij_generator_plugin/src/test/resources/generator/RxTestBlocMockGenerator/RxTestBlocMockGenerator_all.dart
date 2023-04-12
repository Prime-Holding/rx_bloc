import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_list/models.dart';

import 'package:rxdart/rxdart.dart';
import 'sample_mock.mocks.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';


@GenerateMocks([SampleBlocStates, SampleBlocEvents, SampleBlocType])
SampleBlocType sampleMockFactory({
   String? state1,
  String? stateNullable1,
  Result<String>? stateResult2,
  List<CustomType>? stateListOfCustomType,
  PaginatedList<CustomType2>? statePaginatedResult3,
  bool? connectableState,

}) {
  final blocMock = MockSampleBlocType();
  final eventsMock = MockSampleBlocEvents();
  final statesMock = MockSampleBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);


  when(statesMock.state0void).thenAnswer(
    (_) =>  const Stream.empty(),
  );

  when(statesMock.state1).thenAnswer(
    (_) => state1 != null ? Stream.value(state1) : const Stream.empty(),
  );

  when(statesMock.stateNullable1).thenAnswer(
    (_) => stateNullable1 != null ? Stream.value(stateNullable1) : const Stream.empty(),
  );

  when(statesMock.stateResult2).thenAnswer(
    (_) => stateResult2 != null ? Stream.value(stateResult2) : const Stream.empty(),
  );

  when(statesMock.stateListOfCustomType).thenAnswer(
    (_) => stateListOfCustomType != null ? Stream.value(stateListOfCustomType) : const Stream.empty(),
  );

  when(statesMock.statePaginatedResult3).thenAnswer(
    (_) => statePaginatedResult3 != null ? Stream.value(statePaginatedResult3) : const Stream.empty(),
  );

  when(statesMock.connectableState).thenAnswer(
    (_) => connectableState != null ? Stream.value(connectableState).publish() : const Stream<bool>.empty().publish(),
  );


  return blocMock;
}