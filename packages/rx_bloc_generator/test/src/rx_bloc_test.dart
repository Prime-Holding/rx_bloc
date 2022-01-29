@Tags(['not-tests'])
import 'package:rx_bloc/rx_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';
import 'package:test/test.dart';

part 'test_utilities.dart';

@ShouldGenerate(r'''
part of 'rx_bloc_test.dart';

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

  /// Тhe [Subject] where events sink to by calling [withoutAny]
  final _$withoutAnyEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [withPositionalParam]
  final _$withPositionalParamEvent = PublishSubject<int>();

  /// Тhe [Subject] where events sink to by calling [withOptionalParam]
  final _$withOptionalParamEvent = PublishSubject<int?>();

  /// Тhe [Subject] where events sink to by calling [withNamedParam]
  final _$withNamedParamEvent = PublishSubject<int?>();

  /// Тhe [Subject] where events sink to by calling [withOptionalDefaultParam]
  final _$withOptionalDefaultParamEvent = PublishSubject<int>();

  /// Тhe [Subject] where events sink to by calling [withOptionalDefaultEnum]
  final _$withOptionalDefaultEnumEvent = PublishSubject<TestEnumParam>();

  /// Тhe [Subject] where events sink to by calling [withNamedDefaultEnum]
  final _$withNamedDefaultEnumEvent = PublishSubject<TestEnumParam>();

  /// Тhe [Subject] where events sink to by calling [withNamedDefaultParam]
  final _$withNamedDefaultParamEvent = PublishSubject<int>();

  /// Тhe [Subject] where events sink to by calling [withPositionalAndOptional]
  final _$withPositionalAndOptionalEvent =
      PublishSubject<_WithPositionalAndOptionalEventArgs>();

  /// Тhe [Subject] where events sink to by calling [withPositionalAndNamed]
  final _$withPositionalAndNamedEvent =
      PublishSubject<_WithPositionalAndNamedEventArgs>();

  /// Тhe [Subject] where events sink to by calling
  /// [withPositionalAndOptionalDefaultParam]
  final _$withPositionalAndOptionalDefaultParamEvent =
      PublishSubject<_WithPositionalAndOptionalDefaultParamEventArgs>();

  /// Тhe [Subject] where events sink to by calling
  /// [withPositionalAndNamedDefaultParam]
  final _$withPositionalAndNamedDefaultParamEvent =
      PublishSubject<_WithPositionalAndNamedDefaultParamEventArgs>();

  /// Тhe [Subject] where events sink to by calling [with2Positional]
  final _$with2PositionalEvent = PublishSubject<_With2PositionalEventArgs>();

  /// Тhe [Subject] where events sink to by calling [with2Optional]
  final _$with2OptionalEvent = PublishSubject<_With2OptionalEventArgs>();

  /// Тhe [Subject] where events sink to by calling [with2Named]
  final _$with2NamedEvent = PublishSubject<_With2NamedEventArgs>();

  /// Тhe [Subject] where events sink to by calling [with2OptionalDefault]
  final _$with2OptionalDefaultEvent =
      PublishSubject<_With2OptionalDefaultEventArgs>();

  /// Тhe [Subject] where events sink to by calling [with2NamedDefault]
  final _$with2NamedDefaultEvent =
      PublishSubject<_With2NamedDefaultEventArgs>();

  /// Тhe [Subject] where events sink to by calling [with2PositionalAndOptional]
  final _$with2PositionalAndOptionalEvent =
      PublishSubject<_With2PositionalAndOptionalEventArgs>();

  /// Тhe [Subject] where events sink to by calling [with2PositionalAndNamed]
  final _$with2PositionalAndNamedEvent =
      PublishSubject<_With2PositionalAndNamedEventArgs>();

  /// Тhe [Subject] where events sink to by calling [withPositionalAnd2Optional]
  final _$withPositionalAnd2OptionalEvent =
      PublishSubject<_WithPositionalAnd2OptionalEventArgs>();

  /// Тhe [Subject] where events sink to by calling [withPositionalAnd2Named]
  final _$withPositionalAnd2NamedEvent =
      PublishSubject<_WithPositionalAnd2NamedEventArgs>();

  /// Тhe [Subject] where events sink to by calling
  /// [withPositionalAnd1Named1Required]
  final _$withPositionalAnd1Named1RequiredEvent =
      PublishSubject<_WithPositionalAnd1Named1RequiredEventArgs>();

  /// Тhe [Subject] where events sink to by calling [withTwoNamedRequired]
  final _$withTwoNamedRequiredEvent =
      PublishSubject<_WithTwoNamedRequiredEventArgs>();

  /// Тhe [Subject] where events sink to by calling
  /// [withAnnotationAndPositional]
  final _$withAnnotationAndPositionalEvent = BehaviorSubject<int>.seeded(0);

  /// Тhe [Subject] where events sink to by calling
  /// [withAnnotationAnd2Positional]
  final _$withAnnotationAnd2PositionalEvent =
      BehaviorSubject<_WithAnnotationAnd2PositionalEventArgs>.seeded(
          const _WithAnnotationAnd2PositionalEventArgs(1, 2));

  /// Тhe [Subject] where events sink to by calling
  /// [withSeededPositionalAndOptional]
  final _$withSeededPositionalAndOptionalEvent =
      BehaviorSubject<_WithSeededPositionalAndOptionalEventArgs>.seeded(
          const _WithSeededPositionalAndOptionalEventArgs(1, 2));

  /// Тhe [Subject] where events sink to by calling
  /// [withSeededTwoPositionalOptionalDefaultNull]
  final _$withSeededTwoPositionalOptionalDefaultNullEvent =
      BehaviorSubject<_WithAnnotationAnd2PositionalEventArgs?>.seeded(null);

  /// Тhe [Subject] where events sink to by calling
  /// [withSeededTwoPositionalOptional]
  final _$withSeededTwoPositionalOptionalEvent =
      BehaviorSubject<_WithAnnotationAnd2PositionalEventArgs?>.seeded(
          TestEnumParam.seed);

  /// Тhe [Subject] where events sink to by calling [withSeededPositionalEnum]
  final _$withSeededPositionalEnumEvent =
      BehaviorSubject<TestEnumParam>.seeded(TestEnumParam.seed);

  /// Тhe [Subject] where events sink to by calling [withSeeded2PositionalEnum]
  final _$withSeeded2PositionalEnumEvent =
      BehaviorSubject<_WithSeeded2PositionalEnumEventArgs>.seeded(
          const _WithSeeded2PositionalEnumEventArgs(1, TestEnumParam.seed));

  /// Тhe [Subject] where events sink to by calling [withAnnotationNoSeed]
  final _$withAnnotationNoSeedEvent = BehaviorSubject<int>();

  /// The state of [isNotIgnored] implemented in [_mapToIsNotIgnoredState]
  late final Stream<bool> _isNotIgnoredState = _mapToIsNotIgnoredState();

  @override
  void withoutAny() => _$withoutAnyEvent.add(null);

  @override
  void withPositionalParam(int pp) => _$withPositionalParamEvent.add(pp);

  @override
  void withOptionalParam([int? op]) => _$withOptionalParamEvent.add(op);

  @override
  void withNamedParam({int? np}) => _$withNamedParamEvent.add(np);

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
  void withPositionalAndOptional(int pp, [int? op]) =>
      _$withPositionalAndOptionalEvent
          .add(_WithPositionalAndOptionalEventArgs(pp, op));

  @override
  void withPositionalAndNamed(int pp, {required int np}) =>
      _$withPositionalAndNamedEvent
          .add(_WithPositionalAndNamedEventArgs(pp, np: np));

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
  void with2Optional([int? op1, int? op2]) =>
      _$with2OptionalEvent.add(_With2OptionalEventArgs(op1, op2));

  @override
  void with2Named({required int np1, required int np2}) =>
      _$with2NamedEvent.add(_With2NamedEventArgs(np1: np1, np2: np2));

  @override
  void with2OptionalDefault([int op1 = 0, int op2 = 0]) =>
      _$with2OptionalDefaultEvent.add(_With2OptionalDefaultEventArgs(op1, op2));

  @override
  void with2NamedDefault({int np1 = 0, int np2 = 0}) => _$with2NamedDefaultEvent
      .add(_With2NamedDefaultEventArgs(np1: np1, np2: np2));

  @override
  void with2PositionalAndOptional(int pp1, int pp2, [int? op1]) =>
      _$with2PositionalAndOptionalEvent
          .add(_With2PositionalAndOptionalEventArgs(pp1, pp2, op1));

  @override
  void with2PositionalAndNamed(int pp1, int pp2, {required int np1}) =>
      _$with2PositionalAndNamedEvent
          .add(_With2PositionalAndNamedEventArgs(pp1, pp2, np1: np1));

  @override
  void withPositionalAnd2Optional(int pp, [int? op1, int? op2]) =>
      _$withPositionalAnd2OptionalEvent
          .add(_WithPositionalAnd2OptionalEventArgs(pp, op1, op2));

  @override
  void withPositionalAnd2Named(int pp, {int? np1, int? np2}) =>
      _$withPositionalAnd2NamedEvent
          .add(_WithPositionalAnd2NamedEventArgs(pp, np1: np1, np2: np2));

  @override
  void withPositionalAnd1Named1Required(int pp, {int? np1, required int np2}) =>
      _$withPositionalAnd1Named1RequiredEvent.add(
          _WithPositionalAnd1Named1RequiredEventArgs(pp, np1: np1, np2: np2));

  @override
  void withTwoNamedRequired({required int nr, required bool nr2}) =>
      _$withTwoNamedRequiredEvent
          .add(_WithTwoNamedRequiredEventArgs(nr: nr, nr2: nr2));

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
  void withSeededTwoPositionalOptionalDefaultNull(
          _WithAnnotationAnd2PositionalEventArgs? op) =>
      _$withSeededTwoPositionalOptionalDefaultNullEvent.add(op);

  @override
  void withSeededTwoPositionalOptional(
          _WithAnnotationAnd2PositionalEventArgs? op) =>
      _$withSeededTwoPositionalOptionalEvent.add(op);

  @override
  void withSeededPositionalEnum(TestEnumParam op) =>
      _$withSeededPositionalEnumEvent.add(op);

  @override
  void withSeeded2PositionalEnum(int pp1, TestEnumParam pp2) =>
      _$withSeeded2PositionalEnumEvent
          .add(_WithSeeded2PositionalEnumEventArgs(pp1, pp2));

  @override
  void withAnnotationNoSeed(int pp) => _$withAnnotationNoSeedEvent.add(pp);

  @override
  Stream<bool> get isNotIgnored => _isNotIgnoredState;

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
    _$withPositionalAnd1Named1RequiredEvent.close();
    _$withTwoNamedRequiredEvent.close();
    _$withAnnotationAndPositionalEvent.close();
    _$withAnnotationAnd2PositionalEvent.close();
    _$withSeededPositionalAndOptionalEvent.close();
    _$withSeededTwoPositionalOptionalDefaultNullEvent.close();
    _$withSeededTwoPositionalOptionalEvent.close();
    _$withSeededPositionalEnumEvent.close();
    _$withSeeded2PositionalEnumEvent.close();
    _$withAnnotationNoSeedEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withPositionalAndOptional] event
class _WithPositionalAndOptionalEventArgs {
  const _WithPositionalAndOptionalEventArgs(this.pp, [this.op]);

  final int pp;

  final int? op;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withPositionalAndNamed] event
class _WithPositionalAndNamedEventArgs {
  const _WithPositionalAndNamedEventArgs(this.pp, {required this.np});

  final int pp;

  final int np;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withPositionalAndOptionalDefaultParam] event
class _WithPositionalAndOptionalDefaultParamEventArgs {
  const _WithPositionalAndOptionalDefaultParamEventArgs(this.pp, [this.op = 0]);

  final int pp;

  final int op;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withPositionalAndNamedDefaultParam] event
class _WithPositionalAndNamedDefaultParamEventArgs {
  const _WithPositionalAndNamedDefaultParamEventArgs(this.pp, {this.np = 0});

  final int pp;

  final int np;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.with2Positional] event
class _With2PositionalEventArgs {
  const _With2PositionalEventArgs(this.pp1, this.pp2);

  final int pp1;

  final int pp2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.with2Optional] event
class _With2OptionalEventArgs {
  const _With2OptionalEventArgs([this.op1, this.op2]);

  final int? op1;

  final int? op2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.with2Named] event
class _With2NamedEventArgs {
  const _With2NamedEventArgs({required this.np1, required this.np2});

  final int np1;

  final int np2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.with2OptionalDefault] event
class _With2OptionalDefaultEventArgs {
  const _With2OptionalDefaultEventArgs([this.op1 = 0, this.op2 = 0]);

  final int op1;

  final int op2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.with2NamedDefault] event
class _With2NamedDefaultEventArgs {
  const _With2NamedDefaultEventArgs({this.np1 = 0, this.np2 = 0});

  final int np1;

  final int np2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.with2PositionalAndOptional] event
class _With2PositionalAndOptionalEventArgs {
  const _With2PositionalAndOptionalEventArgs(this.pp1, this.pp2, [this.op1]);

  final int pp1;

  final int pp2;

  final int? op1;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.with2PositionalAndNamed] event
class _With2PositionalAndNamedEventArgs {
  const _With2PositionalAndNamedEventArgs(this.pp1, this.pp2,
      {required this.np1});

  final int pp1;

  final int pp2;

  final int np1;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withPositionalAnd2Optional] event
class _WithPositionalAnd2OptionalEventArgs {
  const _WithPositionalAnd2OptionalEventArgs(this.pp, [this.op1, this.op2]);

  final int pp;

  final int? op1;

  final int? op2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withPositionalAnd2Named] event
class _WithPositionalAnd2NamedEventArgs {
  const _WithPositionalAnd2NamedEventArgs(this.pp, {this.np1, this.np2});

  final int pp;

  final int? np1;

  final int? np2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withPositionalAnd1Named1Required] event
class _WithPositionalAnd1Named1RequiredEventArgs {
  const _WithPositionalAnd1Named1RequiredEventArgs(this.pp,
      {this.np1, required this.np2});

  final int pp;

  final int? np1;

  final int np2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withTwoNamedRequired] event
class _WithTwoNamedRequiredEventArgs {
  const _WithTwoNamedRequiredEventArgs({required this.nr, required this.nr2});

  final int nr;

  final bool nr2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withAnnotationAnd2Positional] event
class _WithAnnotationAnd2PositionalEventArgs {
  const _WithAnnotationAnd2PositionalEventArgs(this.pp1, this.pp2);

  final int pp1;

  final int pp2;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withSeededPositionalAndOptional] event
class _WithSeededPositionalAndOptionalEventArgs {
  const _WithSeededPositionalAndOptionalEventArgs(this.pp, [this.op]);

  final int pp;

  final int op;
}

/// Helps providing the arguments in the [Subject.add] for
/// [CounterBlocEvents.withSeeded2PositionalEnum] event
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

  void withOptionalParam([int? op]);

  void withNamedParam({int? np});

  void withOptionalDefaultParam([int op = 1]);

  void withOptionalDefaultEnum([TestEnumParam op = TestEnumParam.optional]);

  void withNamedDefaultEnum({TestEnumParam op = TestEnumParam.optional});

  void withNamedDefaultParam({int np = 1});

  void withPositionalAndOptional(int pp, [int? op]);

  void withPositionalAndNamed(int pp, {required int np});

  void withPositionalAndOptionalDefaultParam(int pp, [int op = 0]);

  void withPositionalAndNamedDefaultParam(int pp, {int np = 0});

  void with2Positional(int pp1, int pp2);

  void with2Optional([int? op1, int? op2]);

  void with2Named({required int np1, required int np2});

  void with2OptionalDefault([int op1 = 0, int op2 = 0]);

  void with2NamedDefault({int np1 = 0, int np2 = 0});

  void with2PositionalAndOptional(int pp1, int pp2, [int? op1]);

  void with2PositionalAndNamed(int pp1, int pp2, {required int np1});

  void withPositionalAnd2Optional(int pp, [int? op1, int? op2]);

  void withPositionalAnd2Named(int pp, {int? np1, int? np2});

  void withPositionalAnd1Named1Required(int pp, {int? np1, required int np2});

  void withTwoNamedRequired({required int nr, required bool nr2});

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
    seed: null,
  )
  void withSeededTwoPositionalOptionalDefaultNull(
    _WithAnnotationAnd2PositionalEventArgs? op,
  );

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: TestEnumParam.seed,
  )
  void withSeededTwoPositionalOptional(
    _WithAnnotationAnd2PositionalEventArgs? op,
  );

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

  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void withAnnotationNoSeed(int pp);
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  @RxBlocIgnoreState()
  Stream<bool> get isIgnored;

  Stream<bool> get isNotIgnored;
}
