import '../models/errors/error_model.dart';

mixin ErrorHandlingMixin {
  T handleError<T>(
    Object? error,
    T function,
  ) {
    if (error is NoConnectionErrorModel) {
      return function;
    }
    throw error ?? UnknownErrorModel();
  }

  Future<T> handleErrorAsync<T>(
    Object? error,
    Future<T> function,
  ) {
    if (error is NoConnectionErrorModel) {
      return function;
    }
    throw error is ErrorModel ? error : UnknownErrorModel();
  }
}
