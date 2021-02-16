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

  /// The state of [count] implemented in [_mapToCountState]
  Stream<int> _countState;

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  Stream<bool> _isLoadingState;

  /// The state of [errors] implemented in [_mapToErrorsState]
  Stream<String> _errorsState;

  @override
  void increment() => _$incrementEvent.add(null);

  @override
  void decrement() => _$decrementEvent.add(null);

  @override
  Stream<int> get count => _countState ??= _mapToCountState();

  @override
  Stream<bool> get isLoading => _isLoadingState ??= _mapToIsLoadingState();

  @override
  Stream<String> get errors => _errorsState ??= _mapToErrorsState();

  Stream<int> _mapToCountState();

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  @override
  void dispose() {
    _$incrementEvent.close();
    _$decrementEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
