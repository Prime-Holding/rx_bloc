import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import '../app/blocs/counter_bloc.dart';
import '../app/repositories/counter_repository.dart';

class BlocImpl extends RxBlocBase implements RxBlocTypeBase {}

void main() {
  group('CounterBloc: _sharedStream', () {
    test('CounterBloc: _sharedStream - PublishSubject', () {
      final bloc = BlocImpl();
      final errorResult = Stream.error(Exception('test')).asResultStream();

      final result = errorResult.setResultStateHandler(
        bloc,
        shareReplay: false,
      );

      expect(result, isA<PublishSubject<Result<dynamic>>>());
    });

    test('CounterBloc: _sharedStream - ReplaySubject', () {
      final bloc = BlocImpl();
      final errorResult = Stream.error(Exception('test')).asResultStream();

      final result = errorResult.setResultStateHandler(
        bloc,
        shareReplay: true,
      );

      expect(result, isA<ReplaySubject<Result<dynamic>>>());
    });
  });

  group('CounterBloc: isLoading', () {
    rxBlocTest<CounterBlocType, LoadingWithTag>(
      'CounterBloc: dispose',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoadingWithTag,
      act: (bloc) async => bloc
        ..events.increment()
        ..dispose(),
      expect: <LoadingWithTag>[LoadingWithTag(loading: false)],
    );

    rxBlocTest<CounterBlocType, LoadingWithTag>(
      'CounterBloc: isLoadingWithTag: no count subscription',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoadingWithTag,
      act: (bloc) async => bloc.events.increment(),
      expect: <LoadingWithTag>[LoadingWithTag(loading: false)],
    );

    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc: isLoading: no count subscription',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async => bloc.events.increment(),
      expect: <bool>[false],
    );

    rxBlocTest<CounterBlocType, LoadingWithTag>(
      'CounterBloc: isLoadingWithTag one increment event',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoadingWithTag,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
      },
      expect: <LoadingWithTag>[
        LoadingWithTag(loading: false),
        LoadingWithTag(loading: true, tag: CounterBloc.incrementTag),
        LoadingWithTag(loading: false, tag: CounterBloc.incrementTag),
      ],
    );

    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc: isLoading one increment event',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
      },
      expect: <bool>[false, true, false],
    );

    rxBlocTest<CounterBlocType, LoadingWithTag>(
      'CounterBloc - isLoadingWithTag one decrement event',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoadingWithTag,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.decrement();
      },
      expect: <LoadingWithTag>[
        LoadingWithTag(loading: false),
        LoadingWithTag(loading: true, tag: CounterBloc.decrementTag),
        LoadingWithTag(loading: false, tag: CounterBloc.decrementTag),
      ],
    );

    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc - isLoading one decrement event',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.decrement();
      },
      expect: <bool>[false, true, false],
    );

    rxBlocTest<CounterBlocType, LoadingWithTag>(
      'CounterBloc - isLoadingWithTag multiple increment and decrement events',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoadingWithTag,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
        bloc.events.increment();
        await Future.delayed(CounterRepository.delayTest);
        bloc.events.increment();
        await Future.delayed(CounterRepository.delayTest);
        bloc.events.decrement();
        await Future.delayed(CounterRepository.delayTest);
        bloc.events.increment();
        bloc.events.decrement();
        // await Future.delayed(const Duration(milliseconds: 110));
      },
      expect: <LoadingWithTag>[
        LoadingWithTag(loading: false),
        LoadingWithTag(loading: true, tag: CounterBloc.incrementTag),
        LoadingWithTag(loading: false, tag: CounterBloc.incrementTag),
        LoadingWithTag(loading: true, tag: CounterBloc.incrementTag),
        LoadingWithTag(loading: false, tag: CounterBloc.incrementTag),
        LoadingWithTag(loading: true, tag: CounterBloc.decrementTag),
        LoadingWithTag(loading: false, tag: CounterBloc.decrementTag),
        LoadingWithTag(loading: true, tag: CounterBloc.incrementTag),
        LoadingWithTag(loading: true, tag: CounterBloc.decrementTag),
        LoadingWithTag(loading: false, tag: CounterBloc.incrementTag),
        LoadingWithTag(loading: false, tag: CounterBloc.decrementTag),
      ],
    );

    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc - isLoading multiple increment and decrement events',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
        bloc.events.increment();
        await Future.delayed(CounterRepository.delayTest);
        bloc.events.increment();
        await Future.delayed(CounterRepository.delayTest);
        bloc.events.decrement();
        await Future.delayed(CounterRepository.delayTest);
        bloc.events.increment();
        bloc.events.decrement();
        // await Future.delayed(const Duration(milliseconds: 110));
      },
      expect: <bool>[
        false,
        true,
        false,
        true,
        false,
        true,
        false,
        true,
        true,
        false,
        false,
      ],
    );

    rxBlocTest<CounterBlocType, bool>(
      'CounterBloc - isLoading for tag multiple increment and decrement events',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.isLoadingDecrement,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
        bloc.events.increment();
        await Future.delayed(CounterRepository.delayTest);
        bloc.events.increment();
        await Future.delayed(CounterRepository.delayTest);
        bloc.events.decrement();
        await Future.delayed(CounterRepository.delayTest);
        bloc.events.increment();
        bloc.events.decrement();
        // await Future.delayed(const Duration(milliseconds: 110));
      },
      expect: <bool>[
        false,
        true,
        false,
        true,
        false,
      ],
    );
  });

  group('CounterBloc: count', () {
    rxBlocTest<CounterBlocType, int>(
      'CounterBloc: count: one increment event',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.count,
      act: (bloc) async => bloc.events.increment(),
      expect: <int>[0, 1],
    );

    rxBlocTest<CounterBlocType, int>(
      'CounterBloc: count: two increment event',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.count,
      act: (bloc) async {
        bloc.events.increment();
        bloc.events.increment();
      },
      expect: <int>[0, 1, 2],
    );

    rxBlocTest<CounterBlocType, int>(
      'CounterBloc: count: two increment and one decrement event',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.count,
      act: (bloc) async {
        bloc.events.increment();
        bloc.events.decrement();
        bloc.events.increment();
      },
      expect: <int>[0, 1, 0, 1],
    );
  });

  group('CounterBloc: error', () {
    rxBlocTest<CounterBlocType, String>(
      'CounterBloc: error: no count subscription',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.errors,
      act: (bloc) async => bloc.events.decrement(),
      expect: <String>[],
    );

    rxBlocTest<CounterBlocType, String>(
      'CounterBloc: error: minimum reached',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.errors,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.decrement();
      },
      expect: <String>[
        'tag: decrement with message Exception: Minimum number is reached!'
      ],
    );

    rxBlocTest<CounterBlocType, String>(
      'CounterBloc: error: maximum reached',
      build: () async => CounterBloc(CounterRepository()),
      state: (bloc) => bloc.states.errors,
      act: (bloc) async {
        bloc.states.count.listen((event) {});
        bloc.events.increment();
        bloc.events.increment();
        bloc.events.increment();
        bloc.events.increment();
      },
      expect: <String>[
        'tag: increment with message Exception: Maximum number is reached!'
      ],
    );
  });
}
