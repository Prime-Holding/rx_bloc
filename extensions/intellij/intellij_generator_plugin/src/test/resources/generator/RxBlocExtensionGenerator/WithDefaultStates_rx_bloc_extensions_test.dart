part of 'profile_dart_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _ProfileDartExtension on ProfileDartBloc {}

extension _ToError on Stream<Exception> {
  /// TODO: Implement error event-to-state logic
  Stream<String> toMessage() => map((error) => error.toString());
}

extension _MapFetchEventToData on Stream<void> {
  Stream<Result<String>> mapToData(/*{required DataRepository repository}*/) =>
      throttleTime(
        const Duration(milliseconds: 200),
      ).switchMap((value) async* {
        ///TODO: Replace the code below with a repository invocation
        /// Example: (value) => repository.getData().asResultStream()
        yield Result<String>.loading();
        await Future.delayed(const Duration(seconds: 1));
        yield Result<String>.success('Some specific async state');
      });
}