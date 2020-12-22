import 'package:meta/meta.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'loading_bloc.rxb.g.dart';

abstract class LoadingBlocStates {
  ///
  /// The isLoading stream starts with default value false.
  ///
  /// **Example:**
  ///    # Input isLoadingStreams
  ///    - |-------true-----false----------->
  ///    - |-------------true------false->
  ///    - |----------------------------------------true----------false->
  ///    # are merged into one stream *isLoading*
  ///    - |false--true------------false------------true----------false->
  Stream<bool> get isLoading;
}

abstract class LoadingBlocEvents {
  void setLoading({@required bool isLoading});
}

@RxBloc()
class LoadingBloc extends $LoadingBloc {
  /// Default constructor
  LoadingBloc() {
    _$setLoadingEvent
        .map((isLoading) =>
            isLoading ? _loadingCount.value + 1 : _loadingCount.value - 1)
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
