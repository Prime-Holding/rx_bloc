// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'counter_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class CounterBlocType extends RxBlocTypeBase {
  CounterBlocEvents get events;
  CounterBlocStates get states;
}

/// [$CounterBloc] extended by the [CounterBloc]
/// {@nodoc}
abstract class $CounterBloc extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [setCount]
  final _$setCountEvent = PublishSubject<int>();

  /// Тhe [Subject] where events sink to by calling [setLoading]
  final _$setLoadingEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [setError]
  final _$setErrorEvent = PublishSubject<Exception>();

  /// The state of [count] implemented in [_mapToCountState]
  late final Stream<Result<int>> _countState = _mapToCountState();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  @override
  void setCount(int count) => _$setCountEvent.add(count);

  @override
  void setLoading() => _$setLoadingEvent.add(null);

  @override
  void setError(Exception error) => _$setErrorEvent.add(error);

  @override
  Stream<Result<int>> get count => _countState;

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  Stream<Result<int>> _mapToCountState();

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  @override
  void dispose() {
    _$setCountEvent.close();
    _$setLoadingEvent.close();
    _$setErrorEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
