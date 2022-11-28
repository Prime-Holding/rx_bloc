import '../models/errors/error_model.dart';

extension ExceptionToErrorModel on Exception {
  ErrorModel asErrorModel() => this is ErrorModel
      ? this as ErrorModel
      : ErrorUnknownModel(exception: this);
}

extension StreamExceptionToErrorModel on Stream<Exception> {
  Stream<ErrorModel> mapToErrorModel() =>
      map((exception) => exception.asErrorModel());
}
