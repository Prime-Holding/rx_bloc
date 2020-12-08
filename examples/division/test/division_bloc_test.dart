import 'package:example/bloc/division_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

void main() {
  group('DivisionBloc tests', () {
    final String num1 = '10';
    final String num2 = '5';
    final String expectedSolution = '10.0 / 5.0 = 2.0';

    rxBlocTest<DivisionBloc, String>(
      'DivisionBloc divides successfully two numbers',
      build: () async => DivisionBloc(),
      state: (bloc) => bloc.states.divisionResult,
      act: (bloc) async {
        bloc.events.divideNumbers(num1, num2);
        await Future.delayed(Duration(milliseconds: 1002));
      },
      expect: [expectedSolution],
    );
  });
}
