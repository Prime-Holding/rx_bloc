import 'package:rxdart/rxdart.dart';

import '../extensions.dart';

/// Merges all isLoadingStreams into one isLoading stream
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

/// **Please Note:**
/// *First three input observables overlap each other therefore they are
///    represented with first couple true/false events in isLoading observable,
///    the last input observable does not overlaps with no one therefore is
///    represented as second couple true/false events in isLoading observable*
///
/// *Fore more cases look at* **LoadingViewModelTests**
///
class LoadingBloc {
  /// Loading stream that has only two "next" events. true for show indicator
  /// and false to hide indicator.
  Stream<bool> get isLoading =>
      _isLoadingCount.map((isLoadingCount) => isLoadingCount > 0);

  final _isLoadingCount = BehaviorSubject<int>.seeded(0);

  final _compositeSubscription = CompositeSubscription();

  /// Parameter isLoadingStream: stream that will be used for loading indicator
  void addStream(Stream<bool> isLoadingStream) => isLoadingStream
      .distinct()
      .map((isLoading) => _isLoadingCount.value + (isLoading ? 1 : -1))
      .bind(_isLoadingCount)
      .disposedBy(_compositeSubscription);

  /// Dispose all subscriptions
  void dispose() => _compositeSubscription.dispose();
}
