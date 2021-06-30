import 'dart:convert';

import 'package:dio/dio.dart';

extension ToError on Stream<Exception> {
  /// TODO: Implement error event-to-state logic
  Stream<String> toMessage() =>
      map((errorState) => errorState.toString().replaceAll('Exception:', ''));

  /// Map DioErrors to present readable custom messages in snack bars
  Stream<Exception> mapFromDio() => map((exception) {
        if (exception is DioError) {
          final response = exception.response;

          if (response == null) {
            return Exception('''It looks like the counter server is not running.
You can start it by executing bin/start_server.sh''');
          }

          final message = jsonDecode(response.data)['error'];
          return Exception(message);
        }

        return exception;
      });
}
