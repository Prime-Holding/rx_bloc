part of 'division_bloc.dart';

extension _DivideNumbersEventArgsMappers on Stream<_DivideNumbersEventArgs> {
  Stream<Result<String>> calculateAndFormat(CalculatorRepository repository) =>
      switchMap(
        (args) => repository.calculate(args.a!, args.b!).asResultStream(),
      );
}

extension _ExceptionMappers on Stream<ResultError<dynamic>> {
  Stream<String> toMessage() => map((result) {
        String msg = result.error.toString();
        if (msg.contains('Exception:')) msg = msg.replaceAll('Exception:', '');
        return msg.trim();
      });
}
