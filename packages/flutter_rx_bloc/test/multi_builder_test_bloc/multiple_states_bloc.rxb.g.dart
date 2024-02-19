// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'multiple_states_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class MultipleStatesBlocType extends RxBlocTypeBase {
  MultipleStatesBlocEvents get events;
  MultipleStatesBlocStates get states;
}

/// [$MultipleStatesBloc] extended by the [MultipleStatesBloc]
/// @nodoc
abstract class $MultipleStatesBloc extends RxBlocBase
    implements
        MultipleStatesBlocEvents,
        MultipleStatesBlocStates,
        MultipleStatesBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [addState1]
  final _$addState1Event = BehaviorSubject<String>();

  /// Тhe [Subject] where events sink to by calling [addState2]
  final _$addState2Event = BehaviorSubject<String>();

  /// Тhe [Subject] where events sink to by calling [addState3]
  final _$addState3Event = BehaviorSubject<String>();

  /// The state of [state1] implemented in [_mapToState1State]
  late final Stream<String> _state1State = _mapToState1State();

  /// The state of [state2] implemented in [_mapToState2State]
  late final Stream<String> _state2State = _mapToState2State();

  /// The state of [state3] implemented in [_mapToState3State]
  late final Stream<String> _state3State = _mapToState3State();

  @override
  void addState1(String value) => _$addState1Event.add(value);

  @override
  void addState2(String value) => _$addState2Event.add(value);

  @override
  void addState3(String value) => _$addState3Event.add(value);

  @override
  Stream<String> get state1 => _state1State;

  @override
  Stream<String> get state2 => _state2State;

  @override
  Stream<String> get state3 => _state3State;

  Stream<String> _mapToState1State();

  Stream<String> _mapToState2State();

  Stream<String> _mapToState3State();

  @override
  MultipleStatesBlocEvents get events => this;

  @override
  MultipleStatesBlocStates get states => this;

  @override
  void dispose() {
    _$addState1Event.close();
    _$addState2Event.close();
    _$addState3Event.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
