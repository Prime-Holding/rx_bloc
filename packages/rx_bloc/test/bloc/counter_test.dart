import 'package:test/test.dart';

import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:rx_bloc/rx_bloc.dart';
import '../../example/main.dart';

class BlocImpl extends RxBlocBase implements RxBlocTypeBase {}

void main() {
  group('CounterBloc: isLoading', () {
    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc: isLoading: no count subscription',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async => bloc.events.increment(),
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <bool>[false],
    );

    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc: isLoading one increment event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
      },
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <bool>[false, true, false],
    );

    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc: isLoading one decrement event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.decrement();
      },
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <bool>[false, true, false],
    );

    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc: isLoading two increment event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.increment();
      },
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <bool>[false, true, false],
    );
  });

  group('CounterBloc: count', () {
    rxBlocTest<CounterBlocType, int>(
      'CounterBloc: count: one increment event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.count,
      act: (bloc) async => bloc.events.increment(),
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <int>[0, 1],
    );

    rxBlocTest<CounterBlocType, int>(
      'CounterBloc: count: two increment event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.count,
      act: (bloc) async {
        bloc.events.increment();
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.increment();
      },
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <int>[0, 1, 2],
    );

    rxBlocTest<CounterBlocType, int>(
      'CounterBloc: count: two increment and one decrement event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.count,
      act: (bloc) async {
        bloc.events.increment();
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.decrement();
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.increment();
      },
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <int>[0, 1, 0, 1],
    );
  });

  group('CounterBloc: error', () {
    rxBlocTest<CounterBlocType, String>(
      'CounterBloc: error: no count subscription',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.errors,
      act: (bloc) async => bloc.events.decrement(),
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <String>[],
    );

    rxBlocTest<CounterBlocType, String>(
      'CounterBloc: error: minimum reached',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.errors,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.decrement();
      },
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <String>['Exception: Minimum number is reached!'],
    );

    rxBlocTest<CounterBlocType, String>(
      'CounterBloc: error: maximum reached',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.errors,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.increment();
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.increment();
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.increment();
      },
      wait: ServerSimulator.delay + const Duration(milliseconds: 10),
      expect: <String>['Exception: Maximum number is reached!'],
    );
  });
}
