import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../rx_bloc.dart';

part 'loading_bloc.rxb.g.dart';
part 'loading_bloc_extensions.dart';
part 'loading_bloc_models.dart';

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
  /// [LoadingBlocStates.isLoading]
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
        .bindToLoadingCounts(_loadingCounts)
        .disposedBy(_compositeSubscription);
  }

  final _loadingCounts = BehaviorSubject.seeded({
    '': BehaviorSubject.seeded(
      _TagCountTuple(
        tag: '', // default tag value
        count: 0,
      ),
    )
  });

  final _compositeSubscription = CompositeSubscription();

  @override
  Stream<LoadingWithTag> _mapToIsLoadingWithTagState() =>
      _loadingCounts.mapToLoadingWithTag().shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToIsLoadingState() => _isLoadingWithTagState
      .map((event) => event.loading)
      .shareReplay(maxSize: 1);

  @override
  Stream<bool> isLoadingForTag(String tag) => _isLoadingWithTagState
      .where((event) => event.tag == tag)
      .map((event) => event.loading)
      .startWith(false)
      .shareReplay(maxSize: 1);

  @override
  void dispose() {
    _compositeSubscription.dispose();

    _loadingCounts.forEach(
      (element) {
        for (var subject in element.values) {
          subject.close();
        }
      },
    );

    _loadingCounts.close();

    super.dispose();
  }
}
