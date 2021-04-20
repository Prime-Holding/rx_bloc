part of 'counter_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _CounterExtension on CounterBloc {}

extension _ToError on Stream<Exception> {
  /// TODO: Implement error event-to-state logic
  Stream<String> toMessage() => map((errorState) => errorState.toString());
}
