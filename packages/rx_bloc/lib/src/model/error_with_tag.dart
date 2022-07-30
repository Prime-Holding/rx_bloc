import '../../rx_bloc.dart';

/// Just a simple container of
/// [ErrorWithTag.exception] and [ErrorWithTag.tag]
class ErrorWithTag {
  /// Default constructor
  ErrorWithTag({
    required this.exception,
    this.tag = '',
  });

  /// Constructor that creates an instance from [ResultError]
  factory ErrorWithTag.fromResult(ResultError resultError) => ErrorWithTag(
        exception: resultError.error,
        tag: resultError.tag,
      );

  /// Is loading flag that is used in async operations
  final Exception exception;

  /// A tag that holds the intention of a async result
  final String tag;

  @override
  String toString() => '{loading: exception, tag: $tag}';

  @override
  bool operator ==(dynamic other) {
    if (other is! ErrorWithTag) {
      return false;
    }

    return other.exception == exception && other.tag == tag;
  }

  @override
  int get hashCode => tag.hashCode ^ exception.hashCode;
}
