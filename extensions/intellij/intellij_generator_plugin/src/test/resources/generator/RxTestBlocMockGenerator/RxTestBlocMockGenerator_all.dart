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


  final state0voidState = const Stream<void>.empty();


  final state1State =  state1 != null
    ? Stream.value(state1).shareReplay(maxSize: 1)
    : const Stream<String>.empty();


  final stateNullable1State =  stateNullable1 != null
    ? Stream.value(stateNullable1).shareReplay(maxSize: 1)
    : const Stream<String?>.empty();


  final stateResult2State =  stateResult2 != null
    ? Stream.value(stateResult2).shareReplay(maxSize: 1)
    : const Stream<Result<String>>.empty();


  final stateListOfCustomTypeState =  stateListOfCustomType != null
    ? Stream.value(stateListOfCustomType).shareReplay(maxSize: 1)
    : const Stream<List<CustomType>>.empty();


  final statePaginatedResult3State =  statePaginatedResult3 != null
    ? Stream.value(statePaginatedResult3).shareReplay(maxSize: 1)
    : const Stream<PaginatedList<CustomType2>>.empty();

  final connectableStateState = (connectableState != null
          ? Stream.value(connectableState)
          : const Stream<bool>.empty())
    .publishReplay(maxSize: 1)
    ..connect();

  when(statesMock.state0void).thenAnswer((_) => state0voidState);
  when(statesMock.state1).thenAnswer((_) => state1State);
  when(statesMock.stateNullable1).thenAnswer((_) => stateNullable1State);
  when(statesMock.stateResult2).thenAnswer((_) => stateResult2State);
  when(statesMock.stateListOfCustomType).thenAnswer((_) => stateListOfCustomTypeState);
  when(statesMock.statePaginatedResult3).thenAnswer((_) => statePaginatedResult3State);
  when(statesMock.connectableState).thenAnswer((_) => connectableStateState);


  return blocMock;
}