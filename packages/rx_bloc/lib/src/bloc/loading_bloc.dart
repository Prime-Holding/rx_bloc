import 'package:meta/meta.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'loading_bloc.rxb.g.dart';

/// The states of LoadingBloc
abstract class LoadingBlocStates {
  ///
  /// The isLoading stream starts with initial value false.
  /// It can be triggered by invoking [LoadingBlocEvents.setLoading]
  ///
  /// **Example:**
  ///    # Input [LoadingBlocEvents.setLoading]
  ///    - |-------true-----false----------->
  ///    - |-------------true------false->
  ///    - |----------------------------------------true----------false->
  ///    # are merged into one stream *isLoading*
  ///    - |false--true------------false------------true----------false->
  Stream<bool> get isLoading;
}

/// The events of LoadingBloc
abstract class LoadingBlocEvents {
  /// Set [isLoading] to BloC
  ///
  /// To observe the current loading state subscribe for
  /// [LoadingBlocStates.isLoading]
  void setLoading({required bool isLoading});
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
        .map((isLoading) => isLoading
            ? (_loadingCount.value ?? 0) + 1
            : (_loadingCount.value ?? 0) - 1)
        .bind(_loadingCount)
        .disposedBy(_compositeSubscription);
  }

  final _loadingCount = BehaviorSubject.seeded(0);
  final _compositeSubscription = CompositeSubscription();

  @override
  Stream<bool> _mapToIsLoadingState() => _loadingCount
      .map((count) => count > 0)
      .distinct()
      .startWith(false)
      .distinct()
      .shareReplay(maxSize: 1);
}
