// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'division_bloc.dart';

/// DivisionBlocType class used for blocClass event and state access from widgets
/// {@nodoc}
abstract class DivisionBlocType extends RxBlocTypeBase {
  DivisionBlocEvents get events;
  DivisionBlocStates get states;
}

/// $DivisionBloc class - extended by the CounterBloc bloc
/// {@nodoc}
abstract class $DivisionBloc extends RxBlocBase
    implements DivisionBlocEvents, DivisionBlocStates, DivisionBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [divideNumbers]
  final _$divideNumbersEvent =
      BehaviorSubject.seeded(const _DivideNumbersEventArgs('1.0', '1.0'));

  /// The state of [divisionResult] implemented in [_mapToDivisionResultState]
  Stream<String> _divisionResultState;

  @override
  void divideNumbers(String a, String b) =>
      _$divideNumbersEvent.add(_DivideNumbersEventArgs(a, b));

  @override
  Stream<String> get divisionResult =>
      _divisionResultState ??= _mapToDivisionResultState();

  Stream<String> _mapToDivisionResultState();

  @override
  DivisionBlocEvents get events => this;

  @override
  DivisionBlocStates get states => this;

  @override
  void dispose() {
    _$divideNumbersEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [DivisionBlocEvents.divideNumbers] event
class _DivideNumbersEventArgs {
  const _DivideNumbersEventArgs(this.a, this.b);

  final String a;

  final String b;
}
