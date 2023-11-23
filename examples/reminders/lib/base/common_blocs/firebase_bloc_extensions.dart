part of 'firebase_bloc.dart';

extension _ToError on Stream<Exception> {
  /// Convenience method used to convert an [Exception] to a presentable string
  Stream<String> toMessage() => map((errorState) => errorState.toString());
}
