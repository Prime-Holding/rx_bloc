import 'package:rxdart/rxdart.dart';

import '../extensions.dart';

///
///    Merges all isLoadingObservables into one isLoading observable

/// **Example:**
///    # Input isLoadingObservables
///    - |--true-----false----------->
///    - |-----------true----------false->
///    - |--------true------false->
///    - |-----------------------------------true----------false->
///    # are merged into one observable *isLoading*
///    - |--true-------------------false-----true----------false->

/// **Please Note:**
/// *First three input observables overlap each other therefore they are
///    represented with first couple true/false events in isLoading observable,
///    the last input observable does not overlaps with no one therefore is representer as second couple true/false events in isLoading observable*
///
/// *Fore more cases look at* **LoadingViewModelTests**
///
class LoadingBloc {
  /// Loading observable that has only two "next" events. true for show indicator and false to hide indicator.
  Stream<bool> get isLoading =>
      _isLoadingCount.skip(1).map((isLoadingCount) => isLoadingCount > 0);

  /// Is loading event count
  final _isLoadingCount = BehaviorSubject<int>.seeded(0);

  final _compositeSubscription = CompositeSubscription();

  /// - Parameter isLoadingObservables: observables that will be used for loading indicator
  addStream(Stream<bool> isLoadingStream) => isLoadingStream
      .map((isLoading) => _isLoadingCount.value + (isLoading ? 1 : -1))
      .bind(_isLoadingCount)
      .disposedBy(_compositeSubscription);

  dispose() => _compositeSubscription.dispose();
}
