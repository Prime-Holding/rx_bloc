import 'package:test/test.dart';

// ignore: avoid_relative_lib_imports
import '../../../rx_bloc_test/lib/rx_bloc_test.dart';
import '../../example/main.dart';
// ignore: avoid_relative_lib_imports
import '../../lib/rx_bloc.dart';

class BlocImpl extends RxBlocBase implements RxBlocTypeBase {}

void main() {
  group('CounterBloc: isLoading', () {
    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc: isLoading: no count subscription',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async => bloc.events.increment(),
      wait: ServerSimulator.delayTest,
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
      wait: ServerSimulator.delayTest,
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
      wait: ServerSimulator.delayTest,
      expect: <bool>[false, true, false],
    );

    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc: isLoading two increment event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
        bloc.events.increment();
      },
      wait: ServerSimulator.delayTest,
      expect: <bool>[false, true, false],
    );
  });

  group('CounterBloc: count', () {
    rxBlocTest<CounterBlocType, int>(
      'CounterBloc: count: one increment event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.count,
      act: (bloc) async => bloc.events.increment(),
      wait: ServerSimulator.delayTest,
      expect: <int>[0, 1],
    );

    rxBlocTest<CounterBlocType, int>(
      'CounterBloc: count: two increment event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.count,
      act: (bloc) async {
        bloc.events.increment();
        bloc.events.increment();
      },
      wait: ServerSimulator.delayTest,
      expect: <int>[0, 1, 2],
    );

    rxBlocTest<CounterBlocType, int>(
      'CounterBloc: count: two increment and one decrement event',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.count,
      act: (bloc) async {
        bloc.events.increment();
        bloc.events.decrement();
        bloc.events.increment();
      },
      wait: ServerSimulator.delayTest,
      expect: <int>[0, 1, 0, 1],
    );
  });

  group('CounterBloc: error', () {
    rxBlocTest<CounterBlocType, String>(
      'CounterBloc: error: no count subscription',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.errors,
      act: (bloc) async => bloc.events.decrement(),
      wait: ServerSimulator.delayTest,
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
      wait: ServerSimulator.delayTest,
      expect: <String>['Exception: Minimum number is reached!'],
    );

    rxBlocTest<CounterBlocType, String>(
      'CounterBloc: error: maximum reached',
      build: () async => CounterBloc(ServerSimulator()),
      state: (bloc) => bloc.states.errors,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
        bloc.events.increment();
        bloc.events.increment();
        bloc.events.increment();
      },
      wait: ServerSimulator.delayTest,
      expect: <String>['Exception: Maximum number is reached!'],
    );
  });
}
