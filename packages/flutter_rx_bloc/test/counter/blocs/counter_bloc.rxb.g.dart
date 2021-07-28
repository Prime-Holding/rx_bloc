part of 'counter_bloc.dart';

/// The code below will be automatically generated
/// for you by `rx_bloc_generator`.
///
/// This generated class usually resides in [file-name].rxb.g.dart.
/// Find more info at https://pub.dev/packages/rx_bloc_generator.

/// ********************GENERATED CODE**************************************
/// CounterBlocType class used for bloc event and state access from widgets
abstract class CounterBlocType extends RxBlocTypeBase {
  // ignore: public_member_api_docs
  CounterBlocEvents get events;

  // ignore: public_member_api_docs
  CounterBlocStates get states;
}

/// $CounterBloc class - extended by the CounterBloc bloc
abstract class $CounterBloc extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  final _$setCountEvent = PublishSubject<int>();

  @override
  void setCount(int count) => _$setCountEvent.add(count);

  final _$setLoadingEvent = PublishSubject<void>();

  @override
  void setLoading() => _$setLoadingEvent.add(null);

  final _$setErrorEvent = PublishSubject<Exception>();

  @override
  void setError(Exception error) => _$setErrorEvent.add(error);

  late final Stream<Result<int>> _countState = _mapToCountState();

  @override
  Stream<Result<int>> get count => _countState;

  Stream<Result<int>> _mapToCountState();

  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  @override
  Stream<bool> get isLoading => _isLoadingState;

  Stream<bool> _mapToIsLoadingState();

  late final Stream<String> _errorsState = _mapToErrorsState();

  @override
  Stream<String> get errors => _errorsState;

  Stream<String> _mapToErrorsState();

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  final _compositeSubscription = CompositeSubscription();

  /// Dispose of all the opened streams when the bloc is closed.
  @override
  void dispose() {
    _$setCountEvent.close();
    _$setLoadingEvent.close();
    _$setErrorEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// ********************GENERATED CODE END**************************************
