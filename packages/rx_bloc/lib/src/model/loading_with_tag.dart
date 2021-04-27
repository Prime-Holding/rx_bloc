/// Just a simple container of
/// [LoadingWithTag.isLoading] and [LoadingWithTag.tag]
class LoadingWithTag {
  /// Default constructor
  LoadingWithTag({
    required this.isLoading,
    this.tag = '',
  });

  /// Is loading flag that is used in async operations
  final bool isLoading;

  /// A tag that holds the intention of a async result
  final String tag;

  @override
  String toString() => '{isLoading: $isLoading, tag: $tag}';

  @override
  bool operator ==(dynamic other) {
    if (other is! LoadingWithTag) {
      return false;
    }

    return other.isLoading == isLoading && other.tag == tag;
  }

  @override
  int get hashCode => tag.hashCode ^ isLoading.hashCode;
}
