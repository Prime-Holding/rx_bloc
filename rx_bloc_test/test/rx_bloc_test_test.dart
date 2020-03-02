import 'package:flutter_test/flutter_test.dart';

import '../lib/src/rx_bloc_test.dart';
import 'helpers/counter_bloc.dart';
import 'helpers/details_bloc/details_bloc.dart';

void main() {
  group('CounterBloc tests', () {
    rxBlocTest<CounterBloc, int>(
      'Basic rxBlocTest',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      expect: [],
    );

    rxBlocTest<CounterBloc, int>(
      'Executing action',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      act: (bloc) async => bloc.increase(),
      expect: [1],
    );

    rxBlocTest<CounterBloc, int>(
      'Skipping results (skips 0 and 1)',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      act: (bloc) async {
        bloc.decrease();
        bloc.decrease();
      },
      skip: 2,
      expect: [-2],
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
      expect: [],
    );

    rxBlocTest<DetailsBloc, String>(
      'Waiting for results',
      build: () async => DetailsBloc(repo),
      state: (bloc) => bloc.states.details,
      act: (bloc) async => bloc.events.fetch(),
      wait: Duration(milliseconds: 60),
      expect: ['Success'],
    );
  });
}
