import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test/test.dart';

import 'helpers/counter_bloc.dart';
import 'helpers/details_bloc/details_bloc.dart';

void main() {
  group('CounterBloc tests', () {
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
        bloc..decrease()..decrease();
      },
      skip: 2,
      expect: <int>[-2],
    );
  });

  group('DetailsBloc', () {
    DetailsRepository repo;

    setUp(() {
      repo = DetailsRepository();
    });

    rxBlocTest<DetailsBloc, String>(
      'Empty test bloc',
      build: () async => DetailsBloc(repo),
      state: (bloc) => bloc.states.details,
      expect: <String>[],
    );

    rxBlocTest<DetailsBloc, String>(
      'Waiting for results',
      build: () async => DetailsBloc(repo),
      state: (bloc) => bloc.states.details,
      act: (bloc) async => bloc.events.fetch(),
      wait: const Duration(milliseconds: 60),
      expect: <String>['Success', 'Success'],
    );
  });
}
