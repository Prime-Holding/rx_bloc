import 'package:test/test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/rx_bloc_test.dart';
import 'helpers/counter_bloc.dart';
import 'helpers/details_bloc/details_bloc.dart';

void main() {
  group('CounterBloc tests', () {
    rxBlocTest<CounterBloc, int>(
      'Basic rxBlocTest with wait',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      wait: const Duration(milliseconds: 2),
      expect: <int>[0],
    );

    rxBlocTest<CounterBloc, int>(
      'Basic rxBlocTest',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      expect: <int>[0],
    );

    rxBlocTest<CounterBloc, int>(
      'Executing action',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      act: (bloc) async => bloc.increase(),
      expect: <int>[0, 1],
    );

    rxBlocTest<CounterBloc, int>(
      'Skipping results (skips 0 and 1)',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      act: (bloc) async {
        bloc
          ..decrease()
          ..decrease();
      },
      skip: 2,
      expect: <int>[-2],
    );
  });

  group('DetailsBloc', () {
    late DetailsRepository repo;

    setUp(() {
      repo = DetailsRepository();
    });

    rxBlocTest<DetailsBloc, String>(
      'Email test bloc',
      build: () async => DetailsBloc(repo),
      state: (bloc) => bloc.states.email,
      act: (bloc) async {
        bloc.events.setEmail(' job');
        bloc.events.setEmail(' job@prime');
        bloc.events.setEmail(' job@prime.com ');
      },
      expect: <String>['', 'job@prime.com'],
    );

    rxBlocFakeAsyncTest<DetailsBloc, String>(
      'Email fake async test bloc',
      build: () => DetailsBloc(repo),
      state: (bloc) => bloc.states.email,
      act: (bloc, fakeAsync) {
        bloc.events.setEmail(' job');
        bloc.events.setEmail(' job@prime');
        bloc.events.setEmail(' job@prime.com ');
        fakeAsync.elapse(const Duration(seconds: 3));
      },
      expect: <String>['', 'job@prime.com'],
    );

    rxBlocTest<DetailsBloc, String>(
      'Empty test bloc',
      build: () async => DetailsBloc(repo),
      state: (bloc) => bloc.states.details,
      expect: <String>['Success'],
    );

    rxBlocTest<DetailsBloc, String>(
      'Waiting for results',
      build: () async => DetailsBloc(repo),
      state: (bloc) => bloc.states.details,
      act: (bloc) async => bloc.events.fetch(),
      expect: <String>['Success', 'Success'],
    );
  });
}
