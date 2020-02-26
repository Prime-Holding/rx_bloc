import 'package:rx_bloc_test/src/rx_bloc_test.dart';

import 'Helpers/counter_bloc.dart';

void main() {
  rxBlocTest<CounterBloc, int>(
    'Basic rxBlocTest',
    build: () async => CounterBloc(),
    state: (bloc) => bloc.count,
    expect: [0],
  );

  rxBlocTest<CounterBloc, int>(
    'Executing action',
    build: () async => CounterBloc(),
    state: (bloc) => bloc.count,
    act: (bloc) async => bloc.increase(),
    expect: [0, 1],
  );

  rxBlocTest<CounterBloc, int>(
    'Skipping results',
    build: () async => CounterBloc(),
    state: (bloc) => bloc.count,
    act: (bloc) async => bloc.decrease(),
    skip: 1,
    expect: [-1],
  );

  rxBlocTest<CounterBloc, int>(
    'Expecting nothing',
    build: () async => CounterBloc(),
    state: (bloc) => bloc.count,
    skip: 1,
  );
}
