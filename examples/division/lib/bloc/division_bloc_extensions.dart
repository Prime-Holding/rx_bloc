part of 'division_bloc.dart';

extension _DivideNumbersEventArgsMappers on Stream<_DivideNumbersEventArgs> {
  Stream<Result<String>> calculateAndFormat(CalculatorRepository repository) =>
      switchMap(
        (args) => repository.calculate(args.a!, args.b!).asResultStream(),
      );
}

extension _ExceptionMappers on Stream<Exception> {
  Stream<String> toMessage() => map((error) {
        String msg = error.toString();
        if (msg.contains('Exception:')) msg = msg.replaceAll('Exception:', '');
        return msg.trim();
      });
}
