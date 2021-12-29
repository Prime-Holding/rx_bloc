/// A custom RxBloc Command Exception
class RxBlocCommandException implements Exception {
  /// Exception thrown in case something goes wrong.
  const RxBlocCommandException(this.message);

  /// The message that provides insight into the reason of throwing.
  final String message;
}
