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
  Stream<Result> get result;
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
          (result) => result is ResultLoading
              ? _loadingCount.value!.copyWith(
                  incrementCount: true,
                  result: result,
                )
              : _loadingCount.value!.copyWith(
                  incrementCount: false,
                  result: result,
                ),
        )
        .bind(_loadingCount)
        .disposedBy(_compositeSubscription);
  }

  final _loadingCount = BehaviorSubject<_ResultCountTuple>.seeded(
    _ResultCountTuple(
      count: 0,
      result: Result.success(null),
    ),
  );

  final _compositeSubscription = CompositeSubscription();

  @override
  Stream<Result> _mapToIsLoadingState() => _loadingCount
      .where((event) =>
          (event.result is ResultLoading && event.count <= 1) ||
          (event.result is! ResultLoading && event.count == 0))
      .map((tuple) => tuple.result)
      .shareReplay(maxSize: 1);
}

class _ResultCountTuple {
  _ResultCountTuple({
    required this.result,
    required this.count,
  });

  final Result result;
  final int count;

  _ResultCountTuple copyWith({
    required bool incrementCount,
    Result? result,
  }) =>
      _ResultCountTuple(
        count: incrementCount ? count + 1 : count - 1,
        result: result ?? this.result,
      );

  @override
  String toString() => '{result: $result, count: $count}';
}
