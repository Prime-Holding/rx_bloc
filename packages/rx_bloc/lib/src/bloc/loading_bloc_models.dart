part of 'loading_bloc.dart';

class _TagCountTuple {
  _TagCountTuple({
    required this.tag,
    required this.count,
    this.initial = true,
  });

  final String tag;
  final int count;

  ///TODO: come up with a better name
  bool initial;

  _TagCountTuple copyWith({
    required bool incrementCount,
  }) =>
      _TagCountTuple(
        count: incrementCount ? count + 1 : count - 1,
        tag: tag,
        initial: false,
      );

  @override
  String toString() => '{tag: $tag, count: $count}';
}
