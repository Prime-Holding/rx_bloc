import 'package:rx_bloc/rx_bloc.dart';
import 'package:source_gen_test/annotations.dart';

part 'test_utilities.dart';

@ShouldGenerate(r'''
part of 'rx_bloc_test.dart';

/// CounterBlocType class used for blocClass event and state access from widgets
/// {@nodoc}
abstract class CounterBlocType extends RxBlocTypeBase {
  CounterBlocEvents get events;
  CounterBlocStates get states;
}

/// $CounterBloc class - extended by the CounterBloc bloc
/// {@nodoc}
abstract class $CounterBloc extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  final _$withoutAnyEvent = PublishSubject<void>();

  final _$withPositionalParamEvent = PublishSubject<int>();

  final _$withOptionalParamEvent = PublishSubject<int>();

  final _$withNamedParamEvent = PublishSubject<int>();

  final _$withOptionalDefaultParamEvent = PublishSubject<int>();

  final _$withOptionalDefaultEnumEvent = PublishSubject<TestEnumParam>();

  final _$withNamedDefaultEnumEvent = PublishSubject<TestEnumParam>();

  final _$withNamedDefaultParamEvent = PublishSubject<int>();

  final _$withPositionalAndOptionalEvent =
      PublishSubject<_WithPositionalAndOptionalEventArgs>();

  final _$withPositionalAndNamedEvent =
      PublishSubject<_WithPositionalAndNamedEventArgs>();

  final _$withPositionalAndOptionalDefaultParamEvent =
      PublishSubject<_WithPositionalAndOptionalDefaultParamEventArgs>();

  final _$withPositionalAndNamedDefaultParamEvent =
      PublishSubject<_WithPositionalAndNamedDefaultParamEventArgs>();

  final _$with2PositionalEvent = PublishSubject<_With2PositionalEventArgs>();

  final _$with2OptionalEvent = PublishSubject<_With2OptionalEventArgs>();

  final _$with2NamedEvent = PublishSubject<_With2NamedEventArgs>();

  final _$with2OptionalDefaultEvent =
      PublishSubject<_With2OptionalDefaultEventArgs>();

  final _$with2NamedDefaultEvent =
      PublishSubject<_With2NamedDefaultEventArgs>();

  final _$with2PositionalAndOptionalEvent =
      PublishSubject<_With2PositionalAndOptionalEventArgs>();

  final _$with2PositionalAndNamedEvent =
      PublishSubject<_With2PositionalAndNamedEventArgs>();

  final _$withPositionalAnd2OptionalEvent =
      PublishSubject<_WithPositionalAnd2OptionalEventArgs>();

  final _$withPositionalAnd2NamedEvent =
      PublishSubject<_WithPositionalAnd2NamedEventArgs>();

  final _$withAnnotationAndPositionalEvent = BehaviorSubject.seeded(0);

  final _$withAnnotationAnd2PositionalEvent = BehaviorSubject.seeded(
      const _WithAnnotationAnd2PositionalEventArgs(1, 2));

  final _$withSeededPositionalAndOptionalEvent = BehaviorSubject.seeded(
      const _WithSeededPositionalAndOptionalEventArgs(1, 2));

  final _$withSeededPositionalEnumEvent =
      BehaviorSubject.seeded(TestEnumParam.seed);

  final _$withSeeded2PositionalEnumEvent = BehaviorSubject.seeded(
      const _WithSeeded2PositionalEnumEventArgs(1, TestEnumParam.seed));

  Stream<bool> _isNotIgnoredState;

  @override
  void withoutAny() => _$withoutAnyEvent.add(null);
  @override
  void withPositionalParam(int pp) => _$withPositionalParamEvent.add(pp);
  @override
  void withOptionalParam([int op]) => _$withOptionalParamEvent.add(op);
  @override
  void withNamedParam({int np}) => _$withNamedParamEvent.add(np);
  @override
  void withOptionalDefaultParam([int op = 1]) =>
      _$withOptionalDefaultParamEvent.add(op);
  @override
  void withOptionalDefaultEnum([TestEnumParam op = TestEnumParam.optional]) =>
      _$withOptionalDefaultEnumEvent.add(op);
  @override
  void withNamedDefaultEnum({TestEnumParam op = TestEnumParam.optional}) =>
      _$withNamedDefaultEnumEvent.add(op);
  @override
  void withNamedDefaultParam({int np = 1}) =>
      _$withNamedDefaultParamEvent.add(np);
  @override
  void withPositionalAndOptional(int pp, [int op]) =>
      _$withPositionalAndOptionalEvent
          .add(_WithPositionalAndOptionalEventArgs(pp, op));
  @override
  void withPositionalAndNamed(int pp, [int np]) => _$withPositionalAndNamedEvent
      .add(_WithPositionalAndNamedEventArgs(pp, np));
  @override
  void withPositionalAndOptionalDefaultParam(int pp, [int op = 0]) =>
      _$withPositionalAndOptionalDefaultParamEvent
          .add(_WithPositionalAndOptionalDefaultParamEventArgs(pp, op));
  @override
  void withPositionalAndNamedDefaultParam(int pp, {int np = 0}) =>
      _$withPositionalAndNamedDefaultParamEvent
          .add(_WithPositionalAndNamedDefaultParamEventArgs(pp, np: np));
  @override
  void with2Positional(int pp1, int pp2) =>
      _$with2PositionalEvent.add(_With2PositionalEventArgs(pp1, pp2));
  @override
  void with2Optional([int op1, int op2]) =>
      _$with2OptionalEvent.add(_With2OptionalEventArgs(op1, op2));
  @override
  void with2Named({int np1, int np2}) =>
      _$with2NamedEvent.add(_With2NamedEventArgs(np1: np1, np2: np2));
  @override
  void with2OptionalDefault([int op1 = 0, int op2 = 0]) =>
      _$with2OptionalDefaultEvent.add(_With2OptionalDefaultEventArgs(op1, op2));
  @override
  void with2NamedDefault({int np1 = 0, int np2 = 0}) => _$with2NamedDefaultEvent
      .add(_With2NamedDefaultEventArgs(np1: np1, np2: np2));
  @override
  void with2PositionalAndOptional(int pp1, int pp2, [int op1]) =>
      _$with2PositionalAndOptionalEvent
          .add(_With2PositionalAndOptionalEventArgs(pp1, pp2, op1));
  @override
  void with2PositionalAndNamed(int pp1, int pp2, {int np1}) =>
      _$with2PositionalAndNamedEvent
          .add(_With2PositionalAndNamedEventArgs(pp1, pp2, np1: np1));
  @override
  void withPositionalAnd2Optional(int pp, [int op1, int op2]) =>
      _$withPositionalAnd2OptionalEvent
          .add(_WithPositionalAnd2OptionalEventArgs(pp, op1, op2));
  @override
  void withPositionalAnd2Named(int pp, {int np1, int np2}) =>
      _$withPositionalAnd2NamedEvent
          .add(_WithPositionalAnd2NamedEventArgs(pp, np1: np1, np2: np2));
  @override
  void withAnnotationAndPositional(int pp) =>
      _$withAnnotationAndPositionalEvent.add(pp);
  @override
  void withAnnotationAnd2Positional(int pp1, int pp2) =>
      _$withAnnotationAnd2PositionalEvent
          .add(_WithAnnotationAnd2PositionalEventArgs(pp1, pp2));
  @override
  void withSeededPositionalAndOptional(int pp, [int op]) =>
      _$withSeededPositionalAndOptionalEvent
          .add(_WithSeededPositionalAndOptionalEventArgs(pp, op));
  @override
  void withSeededPositionalEnum(TestEnumParam op) =>
      _$withSeededPositionalEnumEvent.add(op);
  @override
  void withSeeded2PositionalEnum(int pp1, TestEnumParam pp2) =>
      _$withSeeded2PositionalEnumEvent
          .add(_WithSeeded2PositionalEnumEventArgs(pp1, pp2));
  @override
  Stream<bool> get isNotIgnored =>
      _isNotIgnoredState ??= _mapToIsNotIgnoredState();
  Stream<bool> _mapToIsNotIgnoredState();
  @override
  CounterBlocEvents get events => this;
  @override
  CounterBlocStates get states => this;
  @override
  void dispose() {
    _$withoutAnyEvent.close();
    _$withPositionalParamEvent.close();
    _$withOptionalParamEvent.close();
    _$withNamedParamEvent.close();
    _$withOptionalDefaultParamEvent.close();
    _$withOptionalDefaultEnumEvent.close();
    _$withNamedDefaultEnumEvent.close();
    _$withNamedDefaultParamEvent.close();
    _$withPositionalAndOptionalEvent.close();
    _$withPositionalAndNamedEvent.close();
    _$withPositionalAndOptionalDefaultParamEvent.close();
    _$withPositionalAndNamedDefaultParamEvent.close();
    _$with2PositionalEvent.close();
    _$with2OptionalEvent.close();
    _$with2NamedEvent.close();
    _$with2OptionalDefaultEvent.close();
    _$with2NamedDefaultEvent.close();
    _$with2PositionalAndOptionalEvent.close();
    _$with2PositionalAndNamedEvent.close();
    _$withPositionalAnd2OptionalEvent.close();
    _$withPositionalAnd2NamedEvent.close();
    _$withAnnotationAndPositionalEvent.close();
    _$withAnnotationAnd2PositionalEvent.close();
    _$withSeededPositionalAndOptionalEvent.close();
    _$withSeededPositionalEnumEvent.close();
    _$withSeeded2PositionalEnumEvent.close();
    super.dispose();
  }
}

class _WithPositionalAndOptionalEventArgs {
  const _WithPositionalAndOptionalEventArgs(this.pp, [this.op]);

  final int pp;

  final int op;
}

class _WithPositionalAndNamedEventArgs {
  const _WithPositionalAndNamedEventArgs(this.pp, [this.np]);

  final int pp;

  final int np;
}

class _WithPositionalAndOptionalDefaultParamEventArgs {
  const _WithPositionalAndOptionalDefaultParamEventArgs(this.pp, [this.op = 0]);

  final int pp;

  final int op;
}

class _WithPositionalAndNamedDefaultParamEventArgs {
  const _WithPositionalAndNamedDefaultParamEventArgs(this.pp, {this.np = 0});

  final int pp;

  final int np;
}

class _With2PositionalEventArgs {
  const _With2PositionalEventArgs(this.pp1, this.pp2);

  final int pp1;

  final int pp2;
}

class _With2OptionalEventArgs {
  const _With2OptionalEventArgs([this.op1, this.op2]);

  final int op1;

  final int op2;
}

class _With2NamedEventArgs {
  const _With2NamedEventArgs({this.np1, this.np2});

  final int np1;

  final int np2;
}

class _With2OptionalDefaultEventArgs {
  const _With2OptionalDefaultEventArgs([this.op1 = 0, this.op2 = 0]);

  final int op1;

  final int op2;
}

class _With2NamedDefaultEventArgs {
  const _With2NamedDefaultEventArgs({this.np1 = 0, this.np2 = 0});

  final int np1;

  final int np2;
}

class _With2PositionalAndOptionalEventArgs {
  const _With2PositionalAndOptionalEventArgs(this.pp1, this.pp2, [this.op1]);

  final int pp1;

  final int pp2;

  final int op1;
}

class _With2PositionalAndNamedEventArgs {
  const _With2PositionalAndNamedEventArgs(this.pp1, this.pp2, {this.np1});

  final int pp1;

  final int pp2;

  final int np1;
}

class _WithPositionalAnd2OptionalEventArgs {
  const _WithPositionalAnd2OptionalEventArgs(this.pp, [this.op1, this.op2]);

  final int pp;

  final int op1;

  final int op2;
}

class _WithPositionalAnd2NamedEventArgs {
  const _WithPositionalAnd2NamedEventArgs(this.pp, {this.np1, this.np2});

  final int pp;

  final int np1;

  final int np2;
}

class _WithAnnotationAnd2PositionalEventArgs {
  const _WithAnnotationAnd2PositionalEventArgs(this.pp1, this.pp2);

  final int pp1;

  final int pp2;
}

class _WithSeededPositionalAndOptionalEventArgs {
  const _WithSeededPositionalAndOptionalEventArgs(this.pp, [this.op]);

  final int pp;

  final int op;
}

class _WithSeeded2PositionalEnumEventArgs {
  const _WithSeeded2PositionalEnumEventArgs(this.pp1, this.pp2);

  final int pp1;

  final TestEnumParam pp2;
}
''')

@RxBloc()
class CounterBloc {}

/// A contract class containing all events.
abstract class CounterBlocEvents {
  void withoutAny();

  void withPositionalParam(int pp);

  void withOptionalParam([int op]);

  void withNamedParam({int np});

  void withOptionalDefaultParam([int op = 1]);

  void withOptionalDefaultEnum([TestEnumParam op = TestEnumParam.optional]);

  void withNamedDefaultEnum({TestEnumParam op = TestEnumParam.optional});

  void withNamedDefaultParam({int np = 1});

  void withPositionalAndOptional(int pp, [int op]);

  void withPositionalAndNamed(int pp, [int np]);

  void withPositionalAndOptionalDefaultParam(int pp, [int op = 0]);

  void withPositionalAndNamedDefaultParam(int pp, {int np = 0});

  void with2Positional(int pp1, int pp2);

  void with2Optional([int op1, int op2]);

  void with2Named({int np1, int np2});

  void with2OptionalDefault([int op1 = 0, int op2 = 0]);

  void with2NamedDefault({int np1 = 0, int np2 = 0});

  void with2PositionalAndOptional(int pp1, int pp2, [int op1]);

  void with2PositionalAndNamed(int pp1, int pp2, {int np1});

  void withPositionalAnd2Optional(int pp, [int op1, int op2]);

  void withPositionalAnd2Named(int pp, {int np1, int np2});

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: 0)
  void withAnnotationAndPositional(int pp);

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: _WithAnnotationAnd2PositionalEventArgs(1, 2),
  )
  void withAnnotationAnd2Positional(int pp1, int pp2);

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: _WithSeededPositionalAndOptionalEventArgs(1, 2),
  )
  void withSeededPositionalAndOptional(int pp, [int op]);

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: TestEnumParam.seed,
  )
  void withSeededPositionalEnum(TestEnumParam op);

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: _WithSeeded2PositionalEnumEventArgs(1, TestEnumParam.seed),
  )
  void withSeeded2PositionalEnum(int pp1, TestEnumParam pp2);
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  @RxBlocIgnoreState()
  Stream<bool> get isIgnored;

  Stream<bool> get isNotIgnored;
}