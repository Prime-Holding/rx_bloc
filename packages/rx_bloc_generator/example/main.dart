import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'main.rxb.g.dart';

enum EnumParam { zero, one, two, three }

/// A contract class containing all events.
abstract class CounterBlocEvents {
  void simpleMethod();

  void withRequiredParam5(int number);

  @deprecated
  void withRequiredParam4(int number);

  // Event with one parameter
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: 0)
  void withRequiredParam3(int number);

  // Event with one parameter
  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: _WithRequiredParam6EventArgs(1, 2),
  )
  void withRequiredParam6(int number, int numberOne);

  // Event with one parameter
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: 0)
  void withRequiredParam(int number);

  // Event with one parameter
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: 0)
  void withRequiredParam7(int number);

  // Event with one parameter
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: 0)
  void withRequiredParam2(int number);

  void withOptionalDefaultEnumParam([EnumParam number = EnumParam.zero]);

  void withRequired2Params(int number, int numberOne);

  void withNamedParam({int number});

  void withRequiredNamedParam({int number});

  void with2NamedParams({int number, int numberOne});

  void withRequiredAndNamedParam(int number, {int numberOne});

  void with2RequiredAndNamedParam(int number, int numberOne, {int numberTwo});

  void withRequiredAnd2NamedParam(int number, {int numberOne, int numberTwo});

  void withOptionalParam([int number]);

  void with2OptionalParams([int number, int numberOne]);

  void withOptionalDefaultParam([int number = 0]);

  void withRequiredAndOptionalParams(int number, [int numberOne]);

  void withRequiredAndOptionalDefaultParams(int number, [int numberOne = 1]);

  void withRequiredAnd2OptionalDefaultParams(
    int number, [
    int numberOne = 1,
    int numberTwo = 2,
  ]);

  // Event with one parameter
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: 0)
  void withRequiredParamEventTypeAndSeed(int number);
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  @RxBlocIgnoreState()
  Stream<bool> get isIgnored;

  Stream<int> get count;

  Stream<bool> get isLoading;

  Stream<String> get errors;
}

/// A BloC responsible for count calculations
@RxBloc()
class CounterBloc extends $CounterBloc {}
