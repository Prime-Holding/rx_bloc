// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'division_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class DivisionBlocType extends RxBlocTypeBase {
  DivisionBlocEvents get events;
  DivisionBlocStates get states;
}

/// [$DivisionBloc] extended by the [DivisionBloc]
/// @nodoc
abstract class $DivisionBloc extends RxBlocBase
    implements DivisionBlocEvents, DivisionBlocStates, DivisionBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [divideNumbers]
  final _$divideNumbersEvent = BehaviorSubject<DivideNumbersEventArgs>.seeded(
      const DivideNumbersEventArgs('1.0', '1.0'));

  /// The state of [divisionResult] implemented in [_mapToDivisionResultState]
  late final Stream<String> _divisionResultState = _mapToDivisionResultState();

  @override
  void divideNumbers(String? a, String? b) =>
      _$divideNumbersEvent.add(DivideNumbersEventArgs(a, b));

  @override
  Stream<String> get divisionResult => _divisionResultState;

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
class DivideNumbersEventArgs {
  const DivideNumbersEventArgs(this.a, this.b);

  final String? a;

  final String? b;
}
