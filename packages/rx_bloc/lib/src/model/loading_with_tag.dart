/// Just a simple container of
/// [LoadingWithTag.loading] and [LoadingWithTag.tag]
class LoadingWithTag {
  /// Default constructor
  LoadingWithTag({
    required this.loading,
    this.tag = '',
  });

  /// Is loading flag that is used in async operations
  final bool loading;

  /// A tag that holds the intention of a async result
  final String tag;

  @override
  String toString() => '{loading: $loading, tag: $tag}';

  @override
  bool operator ==(dynamic other) {
    if (other is! LoadingWithTag) {
      return false;
    }

    return other.loading == loading && other.tag == tag;
  }

  @override
  int get hashCode => tag.hashCode ^ loading.hashCode;
}
