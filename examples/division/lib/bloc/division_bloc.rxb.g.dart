// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'division_bloc.dart';

/// DivisionBlocType class used for bloc event and state access from widgets
abstract class DivisionBlocType extends RxBlocTypeBase {
  DivisionBlocEvents get events;

  DivisionBlocStates get states;
}

/// $DivisionBloc class - extended by the DivisionBloc bloc
abstract class $DivisionBloc extends RxBlocBase
    implements DivisionBlocEvents, DivisionBlocStates, DivisionBlocType {
  ///region Events

  ///region divideNumbers

  final _$divideNumbersEvent = BehaviorSubject.seeded(_DivideNumbersEventArgs(
    a: '1.0',
    b: '1.0',
  ));
  @override
  void divideNumbers(String a, String b) =>
      _$divideNumbersEvent.add(_DivideNumbersEventArgs(
        a: a,
        b: b,
      ));

  ///endregion divideNumbers

  ///endregion Events

  ///region States

  ///region divisionResult
  Stream<String> _divisionResultState;

  @override
  Stream<String> get divisionResult =>
      _divisionResultState ??= _mapToDivisionResultState();

  Stream<String> _mapToDivisionResultState();

  ///endregion divisionResult

  ///endregion States

  ///region Type

  @override
  DivisionBlocEvents get events => this;

  @override
  DivisionBlocStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams
  void dispose() {
    _$divideNumbersEvent.close();
    super.dispose();
  }
}

/// region Argument classes

/// region _DivideNumbersEventArgs class

class _DivideNumbersEventArgs {
  final String a;
  final String b;

  const _DivideNumbersEventArgs({
    this.a,
    this.b,
  });
}

/// endregion _DivideNumbersEventArgs class

/// endregion Argument classes
