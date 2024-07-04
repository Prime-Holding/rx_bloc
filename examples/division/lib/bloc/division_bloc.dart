import 'package:example/repositories/calculator_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'division_bloc.rxb.g.dart';
part 'division_bloc_extensions.dart';

abstract class DivisionBlocEvents {
  // Event that we use for number division
  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: (a: '10', b: '2'),
  )
  void divideNumbers(String? a, String? b);
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
  DivisionBloc({this.repository = const CalculatorRepository()});

  final CalculatorRepository repository;

  @override
  Stream<String> _mapToDivisionResultState() => _$divideNumbersEvent
      .calculateAndFormat(repository)
      .setResultStateHandler(this)
      .whereSuccess();

  @override
  Stream<bool> get isLoading => loadingState;

  @override
  Stream<String> get errors => errorState.toMessage();
}
