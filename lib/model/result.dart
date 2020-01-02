/// Generic Result class used for converting a future to a stream as representing the following states
/// - Loading
/// - Success
/// - Error
abstract class Result<T> {
  factory Result.success(T data) {
    return ResultSuccess._(data);
  }

  factory Result.loading() {
    return ResultLoading._();
  }

  factory Result.error(Exception error) {
    return ResultError._(error);
  }

  bool get isLoading;
  bool get isSuccess;
  bool get isFail;
}

/// Generic Result class used for converting a future to a stream as representing the loading state
class ResultLoading<T> implements Result<T> {
  ResultLoading._();

  @override
  bool get isLoading => true;

  @override
  bool get isSuccess => false;

  @override
  bool get isFail => false;
}

/// Generic Result class used for converting a future to a stream as representing the success state
class ResultSuccess<T> implements Result<T> {
  ResultSuccess._(this.data);

  final T data;

  @override
  bool get isLoading => false;

  @override
  bool get isSuccess => true;

  @override
  bool get isFail => false;
}

/// Generic Result class used for converting a future to a stream as representing the error state
class ResultError<T> implements Result<T> {
  ResultError._(this.error);

  final Exception error;

  @override
  bool get isLoading => false;

  @override
  bool get isSuccess => false;

  @override
  bool get isFail => true;
}
