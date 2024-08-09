import 'package:example/bloc/division_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('DivisionBloc tests', () {
    const String num1 = '10';
    const String num2 = '5';
    const String expectedSolution = '10.0 / 5.0 = 2.0';

    rxBlocTest<DivisionBloc, String>(
      'DivisionBloc divides successfully two numbers',
      build: () async => DivisionBloc(),
      state: (bloc) => bloc.states.divisionResult,
      act: (bloc) async => bloc.events.divideNumbers(num1, num2),
      expect: [expectedSolution],
    );

    rxBlocTest<DivisionBloc, bool>(
      'Loading handling',
      build: () async => DivisionBloc(),
      state: (bloc) => bloc.states.isLoading,
      act: (bloc) async {
        bloc.states.divisionResult.listen((event) {});
        bloc.events.divideNumbers(num1, num2);
      },
      expect: [false, true, false],
    );

    rxBlocTest<DivisionBloc, String>(
      'Error handling',
      build: () async => DivisionBloc(),
      state: (bloc) => bloc.states.errors,
      act: (bloc) async {
        bloc.states.divisionResult.doOnData(print).listen((event) {});
        bloc.events.divideNumbers('test', '');
      },
      expect: ['Invalid first number.'],
    );
  });
}
