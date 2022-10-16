import 'package:github_search/feature_counter/blocs/counter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'counter_bloc_mock.mocks.dart';

@GenerateMocks([
  CounterBlocEvents,
  CounterBlocStates,
  CounterBlocType,
])
CounterBlocType counterBlocMockFactory({
  int? count,
  String? error,
  LoadingWithTag? isLoading,
}) {
  final counterBloc = MockCounterBlocType();
  final eventsMock = MockCounterBlocEvents();
  final statesMock = MockCounterBlocStates();

  when(counterBloc.events).thenReturn(eventsMock);
  when(counterBloc.states).thenReturn(statesMock);

  when(statesMock.count).thenAnswer(
    (_) => count != null ? Stream.value(count) : const Stream.empty(),
  );

  when(statesMock.errors).thenAnswer(
    (_) => error != null ? Stream.value(error) : const Stream.empty(),
  );

  when(statesMock.isLoading).thenAnswer(
    (_) => isLoading != null ? Stream.value(isLoading) : const Stream.empty(),
  );

  return counterBloc;
}
