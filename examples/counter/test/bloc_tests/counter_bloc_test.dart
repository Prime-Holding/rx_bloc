//@dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../lib/bloc/counter_bloc.dart';
import '../mock.dart';

void main() {
  group('CounterBloc tests', () {
    rxBlocTest<CounterBlocType, int>(
      'Initial state',
      build: () async => CounterBloc(MockCounterRepository()),
      state: (bloc) => bloc.states.count,
      expect: [0],
    );

    rxBlocTest<CounterBlocType, int>(
      'Incrementing value',
      build: () async {
        final mockRepo = MockCounterRepository();
        when(mockRepo.increment()).thenAnswer((_) async => 1);
        return CounterBloc(mockRepo);
      },
      act: (bloc) async => bloc.events.increment(),
      state: (bloc) => bloc.states.count,
      expect: [0, 1],
    );

    rxBlocTest<CounterBlocType, int>(
      'Decrementing value',
      build: () async {
        final mockRepo = MockCounterRepository();
        when(mockRepo.decrement()).thenAnswer((_) async => -1);
        return CounterBloc(mockRepo);
      },
      act: (bloc) async => bloc.events.decrement(),
      state: (bloc) => bloc.states.count,
      expect: [0, -1],
    );

    rxBlocTest<CounterBlocType, int>(
      'Increment and decrement value',
      build: () async {
        final mockRepo = MockCounterRepository();
        when(mockRepo.increment()).thenAnswer((_) async => 1);
        when(mockRepo.decrement()).thenAnswer((_) async => 0);
        return CounterBloc(mockRepo);
      },
      act: (bloc) async {
        bloc.events.increment();
        bloc.events.decrement();
      },
      state: (bloc) => bloc.states.count,
      expect: [0, 1, 0],
    );

    rxBlocTest<CounterBlocType, String>(
      'Error handling',
      build: () async {
        final mockRepo = MockCounterRepository();
        when(mockRepo.increment())
            .thenAnswer((_) => Future.error('test error msg'));
        return CounterBloc(mockRepo);
      },
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
      },
      state: (bloc) => bloc.states.errors,
      expect: ['Exception: test error msg'],
    );

    rxBlocTest<CounterBlocType, bool>(
      'Loading state',
      build: () async {
        final mockRepo = MockCounterRepository();
        when(mockRepo.increment()).thenAnswer((_) async => 1);
        return CounterBloc(mockRepo);
      },
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
      },
      state: (bloc) => bloc.states.isLoading,
      expect: [false, true, false],
    );
  });
}
