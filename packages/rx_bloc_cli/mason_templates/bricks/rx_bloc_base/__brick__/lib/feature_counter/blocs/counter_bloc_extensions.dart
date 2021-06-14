// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'counter_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.

/// Combines data emitted from all events to produce stream of Result<Count>
/// and load the initial data.
extension _CounterExtension on CounterBloc {
  Stream<Result<Count>> get countState => Rx.merge<Result<Count>>([
    // On increment.
    _$incrementEvent
        .switchMap((_) => _repository.increment().asResultStream()),
    // On decrement.
    _$decrementEvent
        .switchMap((_) => _repository.decrement().asResultStream()),
    // Get current value
    _$reloadEvent
        .startWith(null)
        .switchMap((_) => _repository.getCurrent().asResultStream()),
  ]);
}

extension _ToError on Stream<Exception> {
  /// TODO: Implement error event-to-state logic
  Stream<String> toMessage() =>
      map((errorState) => errorState.toString().replaceAll('Exception:', ''));

  /// Map DioErrors to present readable custom messages in snack bars
  Stream<Exception> mapFromDio() => map((exception) {
    if (exception is DioError &&
        exception.message.contains(' http://0.0.0.0:8080/api')) {
      return Exception('Server is not running.');
    }
    if (exception is DioError &&
        exception.response != null &&
        exception.response!.statusCode == 422) {
      final message =
      jsonDecode(exception.response?.data)['title'];
      return Exception(message);
    }
    return exception;
  });
}
