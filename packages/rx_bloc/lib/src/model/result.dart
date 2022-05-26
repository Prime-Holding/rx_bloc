import 'package:collection/collection.dart';

/// A generic Result class used for converting a future to a stream by
/// `AsResultStream.asResultStream`.
///
/// Represents the following states
/// 1. Loading
/// 2. Success
/// 3. Error
abstract class Result<T> {
  /// The success event of a stream.
  factory Result.success(
    T data, {
    String tag = '',
  }) {
    return ResultSuccess._(data, tag: tag);
  }

  /// The loading state of the stream.
  ///
  /// Usually emitted before starting an async task such as API Request.
  factory Result.loading({
    String tag = '',
  }) {
    return ResultLoading._(tag: tag);
  }

  /// Error event of a stream.
  factory Result.error(
    Exception error, {
    String tag = '',
  }) {
    return ResultError._(error, tag: tag);
  }

  ///TODO: add public documentation
  String get tag;
}

/// A generic Result class used for converting a future to a stream.
///
/// Represents the loading state
class ResultLoading<T> implements Result<T> {
  ResultLoading._({this.tag = ''});

  @override
  bool operator ==(dynamic other) {
    return other is ResultLoading<T> && other.tag == tag;
  }

  @override
  int get hashCode => true.hashCode;

  @override
  String tag;

  @override
  String toString() => 'ResultLoading(tag: $tag)';
}

/// A generic Result class used for converting a future to a stream.
///
/// Represents the success state
class ResultSuccess<T> implements Result<T> {
  ResultSuccess._(
    this.data, {
    this.tag = '',
  });

  /// The data of the event
  final T data;

  @override
  bool operator ==(dynamic other) {
    if (other is! ResultSuccess<T>) {
      return false;
    }

    // Compare list
    if (other.data is List && data is List) {
      final _otherData = other.data as List;
      final _data = data as List;

      return other.tag == tag && const ListEquality().equals(_otherData, _data);
    }

    // Compare map
    if (other.data is Map && data is Map) {
      final _otherData = other.data as Map;
      final _data = data as Map;

      return other.tag == tag &&
          const DeepCollectionEquality().equals(_otherData, _data);
    }

    return other.tag == tag && other.data == data;
  }

  @override
  String toString() => 'ResultSuccess(data: $data, tag: $tag)';

  @override
  int get hashCode => T.hashCode ^ tag.hashCode;

  @override
  String tag;
}

/// A generic Result class used for converting a future to a stream.
///
/// Represents the error state
class ResultError<T> implements Result<T> {
  ResultError._(
    this.error, {
    this.tag = '',
  });

  /// The stream error
  final Exception error;

  @override
  bool operator ==(dynamic other) {
    return other is ResultError<T> &&
        other.tag == tag &&
        other.error.toString() == error.toString();
  }

  @override
  String toString() => 'ResultError(error: ${error.toString()}, tag: $tag)';

  @override
  int get hashCode => error.hashCode ^ tag.hashCode;

  @override
  String tag;
}
