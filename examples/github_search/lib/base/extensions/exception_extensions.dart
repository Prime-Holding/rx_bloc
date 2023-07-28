import 'package:dio/dio.dart';

extension ExceptionToMesssage on Exception {
  String toMessage() {
    final error = this;

    if (error is DioException) {
      return _extractMessageFromDio(error);
    }

    return error.toString();
  }
}

String _extractMessageFromDio(DioException error) {
  if (error.response?.data is Map<String, dynamic>) {
    String message = error.response?.data['message'] ?? '';

    message += '. ';

    final errors = error.response?.data['errors'];

    if (errors is List) {
      for (final resourceError in errors) {
        if (resourceError is Map<String, dynamic>) {
          message +=
              'The ${resourceError['resource']} field is ${resourceError['code']}. ';
        }
      }
    }

    return message;
  }

  return error.response?.statusMessage ?? error.toString();
}
