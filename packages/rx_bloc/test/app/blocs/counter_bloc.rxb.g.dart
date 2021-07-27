// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'counter_bloc.dart';

/// NO NEED TO ANALYZE IT!
///
/// The code below will be automatically generated
/// for you by `rx_bloc_generator`.
///
/// This generated class usually resides in [file-name].rxb.g.dart.
/// Find more info at https://pub.dev/packages/rx_bloc_generator.
/// ********************GENERATED CODE**************************************
/// CounterBlocType class used for bloc event and state access from widgets
abstract class CounterBlocType extends RxBlocTypeBase {
  CounterBlocEvents get events;

  CounterBlocStates get states;
}

/// $CounterBloc class - extended by the CounterBloc bloc
abstract class $CounterBloc extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  final _$decrementEvent = PublishSubject<void>();

  @override
  void decrement() => _$decrementEvent.add(null);

  final _$incrementEvent = PublishSubject<void>();

  @override
  void increment() => _$incrementEvent.add(null);

  late final Stream<int> _countState = _mapToCountState();

  @override
  Stream<int> get count => _countState;

  Stream<int> _mapToCountState();

  late final Stream<LoadingWithTag> _isLoadingWithTag =
      _mapToIsLoadingWithTagState();

  @override
  Stream<LoadingWithTag> get isLoadingWithTag => _isLoadingWithTag;

  Stream<LoadingWithTag> _mapToIsLoadingWithTagState();

  late final Stream<bool> _isLoading = _mapToIsLoadingState();

  @override
  Stream<bool> get isLoading => _isLoading;

  Stream<bool> _mapToIsLoadingState();

  late final Stream<bool> _isLoadingDecrement = _mapToIsLoadingDecrementState();

  @override
  Stream<bool> get isLoadingDecrement => _isLoadingDecrement;

  Stream<bool> _mapToIsLoadingDecrementState();

  late final Stream<String> _errorsState = _mapToErrorsState();

  @override
  Stream<String> get errors => _errorsState;

  Stream<String> _mapToErrorsState();

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  /// Dispose of all the opened streams when the bloc is closed.
  @override
  void dispose() {
    _$incrementEvent.close();
    super.dispose();
  }
}

/// ********************GENERATED CODE END**************************************
