import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'division_bloc.rxb.g.dart';
part 'division_bloc_extensions.dart';

abstract class DivisionBlocEvents {
  // Event that we use for number division
  @RxBlocEvent(
      type: RxBlocEventType.behaviour,
      seed: _DivideNumbersEventArgs('1.0', '1.0'))
  void divideNumbers(String a, String b);
}

abstract class DivisionBlocStates {
  // The output string of the division
  Stream<String> get divisionResult;

  // The loading state of the current division
  @RxBlocIgnoreState()
  Stream<bool> get isLoading;

  // The error state where all thrown exceptions are served
  @RxBlocIgnoreState()
  Stream<String> get errors;
}

@RxBloc()
class DivisionBloc extends $DivisionBloc {
  @override
  Stream<String> _mapToDivisionResultState() => _$divideNumbersEvent
      .calculateAndFormat()
      .setResultStateHandler(this)
      .whereSuccess();

  @override
  Stream<bool> get isLoading => loadingState;

  @override
  Stream<String> get errors => errorState.skip(1).toMessage();
}
