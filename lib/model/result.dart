/// A generic Result class used for converting a future to a stream by [Stream.asResultStream()].
///
/// Represents the following states
/// 1. Loading
/// 2. Success
/// 3. Error
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
}

/// A generic Result class used for converting a future to a stream.
///
/// Represents the loading state
class ResultLoading<T> implements Result<T> {
  ResultLoading._();
}

/// A generic Result class used for converting a future to a stream.
///
/// Represents the success state
class ResultSuccess<T> implements Result<T> {
  ResultSuccess._(this.data);

  final T data;
}

/// A generic Result class used for converting a future to a stream.
///
/// Represents the error state
class ResultError<T> implements Result<T> {
  ResultError._(this.error);

  final Exception error;
}
