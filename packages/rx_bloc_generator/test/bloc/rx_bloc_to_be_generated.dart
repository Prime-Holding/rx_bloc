import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'rx_bloc_to_be_generated.rxb.test.g.dart';

enum EnumParam { zero, one, two, three }

/// A contract class containing all events.
abstract class BlocForTestPurposeEvents {
  void simpleMethod();
}

/// A contract class containing all states for our multi state BloC.
abstract class BlocForTestPurposeStates {
  @RxBlocIgnoreState()
  Stream<bool> get isIgnored;

  Stream<int> get count;

  Stream<bool> get isLoading;

  Stream<String> get errors;
}

/// A BloC responsible for count calculations
@RxBloc()
class BlocForTestPurpose extends BlocForTestPurpose {}
