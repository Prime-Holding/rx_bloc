import 'package:example/bloc/counter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc_test/src/rx_bloc_test.dart';

void main() {
  group('CounterBloc tests', () {
    rxBlocTest<CounterBloc, String>(
      'Nothing expected',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.states.count,
      expect: [],
    );

    rxBlocTest<CounterBloc, String>(
      'Incrementing value',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.states.count,
      act: (bloc) async => bloc.events.increment(),
      skip: 1,
      expect: ['1'],
    );

    rxBlocTest<CounterBloc, String>(
      'Decrementing value',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.states.count,
      act: (bloc) async => bloc.events.decrement(),
      skip: 1,
      expect: ['-1'],
    );

    rxBlocTest<CounterBloc, bool>(
      'Incrementing enabled (on zero value)',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.states.incrementEnabled,
      skip: 0,
      expect: [true],
    );

    rxBlocTest<CounterBloc, bool>(
      'Incrementing disabled (after 5 increments)',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.states.incrementEnabled,
      act: (bloc) async {
        for (int i = 0; i < 5; i++) bloc.increment();
      },
      skip: 5,
      expect: [false],
    );

    rxBlocTest<CounterBloc, bool>(
      'Decrementing enabled (after at least one increment)',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.states.decrementEnabled,
      act: (bloc) async => bloc.events.increment(),
      skip: 1,
      expect: [true],
    );

    rxBlocTest<CounterBloc, bool>(
      'Decrementing disabled (on zero value)',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.states.decrementEnabled,
      skip: 0,
      expect: [false],
    );
  });
}
