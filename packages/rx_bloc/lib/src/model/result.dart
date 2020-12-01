/// A generic Result class used for converting a future to a stream by
/// `AsResultStream.asResultStream`.
///
/// Represents the following states
/// 1. Loading
/// 2. Success
/// 3. Error
abstract class Result<T> {
  /// The success event of a stream.
  factory Result.success(T data) {
    return ResultSuccess._(data);
  }

  /// The loading state of the stream.
  ///
  /// Usually emitted before starting an async task such as API Request.
  factory Result.loading() {
    return ResultLoading._();
  }

  /// Error event of a stream.
  factory Result.error(Exception error) {
    return ResultError._(error);
  }
}

/// A generic Result class used for converting a future to a stream.
///
/// Represents the loading state
class ResultLoading<T> implements Result<T> {
  ResultLoading._();

  @override
  bool operator ==(dynamic other) {
    return other is ResultLoading<T>;
  }

  @override
  int get hashCode => true.hashCode;
}

/// A generic Result class used for converting a future to a stream.
///
/// Represents the success state
class ResultSuccess<T> implements Result<T> {
  ResultSuccess._(this.data);

  /// The data of the event
  final T data;

  @override
  bool operator ==(dynamic other) {
    if (other is! ResultSuccess<T>) {
      return false;
    }

    // Compare list
    if (other.data is List && data is List) {
      final data = this.data as List;
      final otherData = other.data as List;

      if (data.isEmpty && otherData.isEmpty) {
        return true;
      }

      return otherData.any(data.contains);
    }

    return other.data == data;
  }

  @override
  String toString() => '$data';

  @override
  int get hashCode => T.hashCode;
}

/// A generic Result class used for converting a future to a stream.
///
/// Represents the error state
class ResultError<T> implements Result<T> {
  ResultError._(this.error);

  /// The stream error
  final Exception error;

  @override
  bool operator ==(dynamic other) {
    return other is ResultError<T> &&
        other.error.toString() == error.toString();
  }

  @override
  String toString() => error.toString();

  @override
  int get hashCode => error.hashCode;
}
