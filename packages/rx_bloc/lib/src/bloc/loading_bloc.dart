import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'loading_bloc.rxb.g.dart';

/// The states of LoadingBloc
abstract class LoadingBlocStates {
  ///
  /// The isLoading stream starts with initial value false.
  /// It can be triggered by invoking [LoadingBlocEvents.setResult]
  ///
  /// **Example:**
  ///    # Input [LoadingBlocEvents.setLoading]
  ///    - |-------true-----false----------->
  ///    - |-------------true------false->
  ///    - |----------------------------------------true----------false->
  ///    # are merged into one stream *isLoading*
  ///    - |false--true------------false------------true----------false->
  Stream<LoadingWithTag> get isLoadingWithTag;

  ///
  /// Get global isLoading stream
  ///
  Stream<bool> get isLoading;

  ///
  /// Get isLoading stream for a specific tag
  ///
  @RxBlocIgnoreState()
  Stream<bool> isLoadingForTag(String tag);
}

/// The events of LoadingBloc
abstract class LoadingBlocEvents {
  /// Set [result] to BloC
  ///
  /// To observe the current loading state subscribe for
  /// [LoadingBlocStates.result]
  void setResult({required Result result});
}

/// The BloC that handles is loading state.
///
/// Each bloc has a internal property of [LoadingBloc], which allows to be used:
/// 1. setStateHandler(...)
/// 2. setLoadingStateHandler(...)
@RxBloc()
class LoadingBloc extends $LoadingBloc {
  /// Default constructor
  LoadingBloc() {
    _$setLoadingEvent
        .map(
          (result) {
            final tuple = _loadingCounts.value!
                .firstWhere((element) => element.tag == result.tag,
                    orElse: () => _TagCountTuple(tag: result.tag, count: 0))
                .copyWith(incrementCount: result is ResultLoading);
            return [
              tuple,
              ..._loadingCounts.value!
                  .where((element) => element.tag != result.tag),
            ];
          },
        )
        .bind(_loadingCounts)
        .disposedBy(_compositeSubscription);
  }

  final _loadingCounts = BehaviorSubject<List<_TagCountTuple>>.seeded(
    [
      _TagCountTuple(
        tag: '', // default tag value
        count: 0,
      ),
    ],
  );

  final _compositeSubscription = CompositeSubscription();

  @override
  Stream<LoadingWithTag> _mapToIsLoadingWithTagState() => _loadingCounts
      .map((counts) =>
          LoadingWithTag(tag: counts.first.tag, loading: counts.isLoading))
      .shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToIsLoadingState() =>
      _loadingCounts.map((counts) => counts.isLoading).shareReplay(maxSize: 1);

  @override
  Stream<bool> isLoadingForTag(String tag) => _loadingCounts
      .map((events) =>
          events
              .firstWhere(
                (element) => element.tag == tag,
                orElse: () => _TagCountTuple(tag: tag, count: 0),
              )
              .count >
          0)
      .shareReplay(maxSize: 1);
}

class _TagCountTuple {
  _TagCountTuple({
    required this.tag,
    required this.count,
  });

  final String tag;
  final int count;

  _TagCountTuple copyWith({
    required bool incrementCount,
  }) =>
      _TagCountTuple(
        count: incrementCount ? count + 1 : count - 1,
        tag: tag,
      );

  @override
  String toString() => '{tag: $tag, count: $count}';
}

extension _IsLoadingHelpers on List<_TagCountTuple> {
  bool get isLoading => any((element) => element.count > 0);
}
