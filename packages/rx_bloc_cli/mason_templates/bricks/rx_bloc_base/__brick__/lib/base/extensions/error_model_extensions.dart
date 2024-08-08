import 'package:dio/dio.dart';

import '../models/errors/error_model.dart';

extension ExceptionToErrorObject on Object {
  ErrorModel asErrorModel() => this is ErrorModel
      ? this as ErrorModel
      : UnknownErrorModel(
          exception: this is Exception ? this as Exception : null);
}

extension ExceptionToErrorModel on Exception {
  ErrorModel asErrorModel() => this is ErrorModel
      ? this as ErrorModel
      : UnknownErrorModel(exception: this);
}

extension StreamExceptionToErrorModel on Stream<Exception> {
  Stream<ErrorModel> mapToErrorModel() =>
      map((exception) => exception.asErrorModel());
}

extension ResponseErrorToString on Response {
  String? mapToString() => data is Map<String, dynamic> ? data['error'] : null;
}
