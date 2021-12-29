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

  /// Тhe [Subject] where events sink to by calling [increment]
  final _$incrementEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [decrement]
  final _$decrementEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [reload]
  final _$reloadEvent = PublishSubject<void>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<LoadingWithTag> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [count] implemented in [_mapToCountState]
  late final Stream<int> _countState = _mapToCountState();

  @override
  void increment() => _$incrementEvent.add(null);

  @override
  void decrement() => _$decrementEvent.add(null);

  @override
  void reload() => _$reloadEvent.add(null);

  @override
  Stream<LoadingWithTag> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  @override
  Stream<int> get count => _countState;

  Stream<LoadingWithTag> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  Stream<int> _mapToCountState();

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  @override
  void dispose() {
    _$incrementEvent.close();
    _$decrementEvent.close();
    _$reloadEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
