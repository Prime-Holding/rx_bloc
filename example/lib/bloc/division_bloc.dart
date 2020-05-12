import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'division_bloc.rxb.g.dart';

abstract class DivisionBlocEvents {
  // Event that we use for number division
  @RxBlocEvent(
      type: RxBlocEventType.behaviour,
      seed: _DivideNumbersEventArgs(a: '1.0', b: '1.0'))
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
      .switchMap((inputArgs) =>
          _calculateAndFormat(inputArgs.a, inputArgs.b).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess();

  Future<String> _calculateAndFormat(String num1, String num2) async {
    // Any thrown exception will be captured by the errorState

    if (num1.isNullOrEmpty || !num1.hasDigitsOnly)
      throw Exception('Invalid first number.');
    if (num2.isNullOrEmpty || !num2.hasDigitsOnly)
      throw Exception('Invalid second number.');

    final numA = double.tryParse(num1);
    final numB = double.tryParse(num2);

    if (numB == 0) throw Exception('Cannot divide by zero.');

    // Simulate a small calculation delay (so the loading progress is visible)
    await Future.delayed(Duration(seconds: 1));
    return '$numA / $numB = ${numA / numB}';
  }

  @override
  Stream<bool> get isLoading => loadingState;

  @override
  Stream<String> get errors => errorState.skip(1).map((exception) {
        String msg = exception.toString();
        if (msg.contains('Exception:')) msg = msg.replaceAll('Exception:', '');
        return msg;
      });
}

extension _StringExtensions on String {
  bool get isNullOrEmpty {
    return this == null || this.trim().isEmpty;
  }

  bool get hasDigitsOnly {
    final _digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < this.length; i++)
      if (!_digits.contains(this[i])) {
        return false;
      }
    return true;
  }
}
