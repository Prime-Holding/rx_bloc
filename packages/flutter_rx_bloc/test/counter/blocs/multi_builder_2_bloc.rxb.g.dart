// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'multi_builder_2_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class MultiBuilder2BlocType extends RxBlocTypeBase {
  MultiBuilder2BlocEvents get events;
  MultiBuilder2BlocStates get states;
}

/// [$MultiBuilder2Bloc] extended by the [MultiBuilder2Bloc]
/// {@nodoc}
abstract class $MultiBuilder2Bloc extends RxBlocBase
    implements
        MultiBuilder2BlocEvents,
        MultiBuilder2BlocStates,
        MultiBuilder2BlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [addState1]
  final _$addState1Event = BehaviorSubject<String>();

  /// Тhe [Subject] where events sink to by calling [addState2]
  final _$addState2Event = BehaviorSubject<String>();

  /// The state of [state1] implemented in [_mapToState1State]
  late final Stream<String> _state1State = _mapToState1State();

  /// The state of [state2] implemented in [_mapToState2State]
  late final Stream<String> _state2State = _mapToState2State();

  @override
  void addState1(String value) => _$addState1Event.add(value);

  @override
  void addState2(String value) => _$addState2Event.add(value);

  @override
  Stream<String> get state1 => _state1State;

  @override
  Stream<String> get state2 => _state2State;

  Stream<String> _mapToState1State();

  Stream<String> _mapToState2State();

  @override
  MultiBuilder2BlocEvents get events => this;

  @override
  MultiBuilder2BlocStates get states => this;

  @override
  void dispose() {
    _$addState1Event.close();
    _$addState2Event.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
