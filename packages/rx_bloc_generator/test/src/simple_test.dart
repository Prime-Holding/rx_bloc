import 'package:rx_bloc/rx_bloc.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldGenerate(r'''
part of 'rx_bloc_test.dart';
''')
@RxBloc()
class CounterBloc {}

/// A contract class containing all events.
abstract class CounterBlocEvents {
  void caseOne(String positionalNT,
      {required String namedRequiredNT, String? namedN});

  void caseTwo(String positionalNT, [String? optionalNDefault = '']);

  void caseThree(String? positionalN, String positionalNT,
      [String? optionalNDefault = '', String? optionalN]);

  void caseFour(String? positionalN, String positionalNT,
      [String? optionalNDefault = '',
      String? optionalN,
      String optionalNTD = 'dasdas']);
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {}
