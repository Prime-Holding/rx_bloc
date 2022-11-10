part of 'firebase_bloc.dart';

extension _ToError on Stream<Exception> {
  Stream<String> toMessage() => map((errorState) => errorState.toString());
}
