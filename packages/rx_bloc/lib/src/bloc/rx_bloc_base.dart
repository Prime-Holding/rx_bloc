import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../model/error_with_tag.dart';
import '../model/loading_with_tag.dart';
import '../model/result.dart';
import 'loading_bloc.dart';

part '../extensions.dart';

// ignore: public_member_api_docs
abstract class RxBlocTypeBase {
  /// Dispose all StreamControllers and Composite Subscriptions
  void dispose();
}

/// A base class that handles all common BloC functionality such as
/// 1. Loading State
/// 2. Error State
abstract class RxBlocBase {
  /// A loading bloc that holds the loading state of all handled result streams.
  ///
  /// To register a result stream either call:
  ///
  /// ```dart
  /// setLoadingStateHandler(resultStream);
  /// ```
  ///
  /// or:
  ///
  /// ```dart
  ///  setResultStateHandler(resultStream);
  /// ```
  ///
  /// To get the stream of all loading states simply call:
  /// ```
  /// _loadingBloc.isLoading
  /// ```
  ///
  final LoadingBloc _loadingBloc = LoadingBloc();

  /// The loading states with tags of all handled result streams.
  @protected
  Stream<LoadingWithTag> get loadingWithTagState =>
      _loadingBloc.states.isLoadingWithTag;

  /// The loading states without tags of all handled result streams.
  @protected
  Stream<bool> get loadingState => _loadingBloc.states.isLoading;

  /// The loading states with tags of all handled result streams.
  @protected
  Stream<bool> loadingForTagState(String tag) =>
      _loadingBloc.states.isLoadingForTag(tag);

  /// The errors of all handled result streams.
  @protected
  Stream<Exception> get errorState =>
      _resultStreamExceptionsSubject.mapToException();

  /// The errors of all handled result streams along with the tag
  @protected
  Stream<ErrorWithTag> get errorWithTagState =>
      _resultStreamExceptionsSubject.mapToErrorWithTag();

  final _resultStreamExceptionsSubject = BehaviorSubject<ResultError>();

  final _compositeSubscription = CompositeSubscription();

  /// Disposes all internally created streams
  void dispose() {
    _resultStreamExceptionsSubject.close();
    _compositeSubscription.dispose();
    _loadingBloc.dispose();
  }
}

extension _StreamAsSharedStream<T> on Stream<T> {
  Stream<T> asSharedStream({bool shareReplay = true}) {
    if (shareReplay) {
      if (this is! ReplayStream<T>) {
        return this.shareReplay(maxSize: 1);
      }
    } else if (this is! PublishSubject<T>) {
      return share();
    }

    return this;
  }
}
