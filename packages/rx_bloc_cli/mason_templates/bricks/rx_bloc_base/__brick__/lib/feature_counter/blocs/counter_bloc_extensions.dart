// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'counter_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _CounterExtension on CounterBloc {}

extension _ToError on Stream<Exception> {
  /// TODO: Implement error event-to-state logic
  Stream<String> toMessage() =>
      map((errorState) => errorState.toString().substring(10));

  /// Map DioError to present readable custom message, thrown from the API
  Stream<Exception> mapFromDio() => map((exception) {
    if (exception is DioError &&
        exception.response != null &&
        exception.response!.statusCode == 422) {
      final message =
      jsonDecode((exception as DioError).response?.data)['title'];
      return Exception(message);
    }
    return exception;
  });
}
