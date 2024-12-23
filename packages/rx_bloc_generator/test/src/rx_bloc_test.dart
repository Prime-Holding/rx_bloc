// ignore_for_file: library_private_types_in_public_api

@Tags(['not-tests'])
import 'package:rx_bloc/rx_bloc.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:source_gen_test/annotations.dart';
import 'package:test/test.dart';

part 'test_utilities.dart';

@ShouldGenerate(r'''
part of 'rx_bloc_test.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class CounterBlocType extends RxBlocTypeBase {
  CounterBlocEvents get events;
  CounterBlocStates get states;
}

/// [$CounterBloc] extended by the [CounterBloc]
/// @nodoc
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
      PublishSubject<({int pp, int? op})>();

  /// Тhe [Subject] where events sink to by calling [withPositionalAndNamed]
  final _$withPositionalAndNamedEvent = PublishSubject<({int pp, int np})>();

  /// Тhe [Subject] where events sink to by calling
  /// [withPositionalAndOptionalDefaultParam]
  final _$withPositionalAndOptionalDefaultParamEvent =
      PublishSubject<({int pp, int op})>();

  /// Тhe [Subject] where events sink to by calling
  /// [withPositionalAndNamedDefaultParam]
  final _$withPositionalAndNamedDefaultParamEvent =
      PublishSubject<({int pp, int np})>();

  /// Тhe [Subject] where events sink to by calling [with2Positional]
  final _$with2PositionalEvent = PublishSubject<({int pp1, int pp2})>();

  /// Тhe [Subject] where events sink to by calling [with2Optional]
  final _$with2OptionalEvent = PublishSubject<({int? op1, int? op2})>();

  /// Тhe [Subject] where events sink to by calling [with2Named]
  final _$with2NamedEvent = PublishSubject<({int np1, int np2})>();

  /// Тhe [Subject] where events sink to by calling [with2OptionalDefault]
  final _$with2OptionalDefaultEvent = PublishSubject<({int op1, int op2})>();

  /// Тhe [Subject] where events sink to by calling [with2NamedDefault]
  final _$with2NamedDefaultEvent = PublishSubject<({int np1, int np2})>();

  /// Тhe [Subject] where events sink to by calling [with2PositionalAndOptional]
  final _$with2PositionalAndOptionalEvent =
      PublishSubject<({int pp1, int pp2, int? op1})>();

  /// Тhe [Subject] where events sink to by calling [with2PositionalAndNamed]
  final _$with2PositionalAndNamedEvent =
      PublishSubject<({int pp1, int pp2, int np1})>();

  /// Тhe [Subject] where events sink to by calling [withPositionalAnd2Optional]
  final _$withPositionalAnd2OptionalEvent =
      PublishSubject<({int pp, int? op1, int? op2})>();

  /// Тhe [Subject] where events sink to by calling [withPositionalAnd2Named]
  final _$withPositionalAnd2NamedEvent =
      PublishSubject<({int pp, int? np1, int? np2})>();

  /// Тhe [Subject] where events sink to by calling
  /// [withPositionalAnd1Named1Required]
  final _$withPositionalAnd1Named1RequiredEvent =
      PublishSubject<({int pp, int? np1, int np2})>();

  /// Тhe [Subject] where events sink to by calling [withTwoNamedRequired]
  final _$withTwoNamedRequiredEvent = PublishSubject<({int nr, bool nr2})>();

  /// Тhe [Subject] where events sink to by calling
  /// [withAnnotationAndPositional]
  final _$withAnnotationAndPositionalEvent = BehaviorSubject<int>.seeded(0);

  /// Тhe [Subject] where events sink to by calling
  /// [withAnnotationAnd2Positional]
  final _$withAnnotationAnd2PositionalEvent =
      BehaviorSubject<({int pp1, int pp2})>.seeded(const (pp1: 1, pp2: 2));

  /// Тhe [Subject] where events sink to by calling
  /// [withSeededPositionalAndOptional]
  final _$withSeededPositionalAndOptionalEvent =
      BehaviorSubject<({int pp, int? op})>.seeded(const (pp: 1, op: 2));

  /// Тhe [Subject] where events sink to by calling
  /// [withSeededTwoPositionalOptionalDefaultNull]
  final _$withSeededTwoPositionalOptionalDefaultNullEvent =
      BehaviorSubject<({int? p1, int? p2})>.seeded(const (p1: null, p2: null));

  /// Тhe [Subject] where events sink to by calling
  /// [withSeededTwoPositionalOptional]
  final _$withSeededTwoPositionalOptionalEvent =
      BehaviorSubject<({int? p1, int? p2})>.seeded(const (p1: 0, p2: 1));

  /// Тhe [Subject] where events sink to by calling [withSeededPositionalEnum]
  final _$withSeededPositionalEnumEvent = BehaviorSubject<TestEnumParam>.seeded(
    TestEnumParam.seed,
  );

  /// Тhe [Subject] where events sink to by calling [withSeeded2PositionalEnum]
  final _$withSeeded2PositionalEnumEvent =
      BehaviorSubject<({int pp1, TestEnumParam pp2})>.seeded(const (
        pp1: 1,
        pp2: TestEnumParam.seed,
      ));

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
      _$withPositionalAndOptionalEvent.add((pp: pp, op: op));

  @override
  void withPositionalAndNamed(int pp, {required int np}) =>
      _$withPositionalAndNamedEvent.add((pp: pp, np: np));

  @override
  void withPositionalAndOptionalDefaultParam(int pp, [int op = 0]) =>
      _$withPositionalAndOptionalDefaultParamEvent.add((pp: pp, op: op));

  @override
  void withPositionalAndNamedDefaultParam(int pp, {int np = 0}) =>
      _$withPositionalAndNamedDefaultParamEvent.add((pp: pp, np: np));

  @override
  void with2Positional(int pp1, int pp2) =>
      _$with2PositionalEvent.add((pp1: pp1, pp2: pp2));

  @override
  void with2Optional([int? op1, int? op2]) =>
      _$with2OptionalEvent.add((op1: op1, op2: op2));

  @override
  void with2Named({required int np1, required int np2}) =>
      _$with2NamedEvent.add((np1: np1, np2: np2));

  @override
  void with2OptionalDefault([int op1 = 0, int op2 = 0]) =>
      _$with2OptionalDefaultEvent.add((op1: op1, op2: op2));

  @override
  void with2NamedDefault({int np1 = 0, int np2 = 0}) =>
      _$with2NamedDefaultEvent.add((np1: np1, np2: np2));

  @override
  void with2PositionalAndOptional(int pp1, int pp2, [int? op1]) =>
      _$with2PositionalAndOptionalEvent.add((pp1: pp1, pp2: pp2, op1: op1));

  @override
  void with2PositionalAndNamed(int pp1, int pp2, {required int np1}) =>
      _$with2PositionalAndNamedEvent.add((pp1: pp1, pp2: pp2, np1: np1));

  @override
  void withPositionalAnd2Optional(int pp, [int? op1, int? op2]) =>
      _$withPositionalAnd2OptionalEvent.add((pp: pp, op1: op1, op2: op2));

  @override
  void withPositionalAnd2Named(int pp, {int? np1, int? np2}) =>
      _$withPositionalAnd2NamedEvent.add((pp: pp, np1: np1, np2: np2));

  @override
  void withPositionalAnd1Named1Required(int pp, {int? np1, required int np2}) =>
      _$withPositionalAnd1Named1RequiredEvent.add((pp: pp, np1: np1, np2: np2));

  @override
  void withTwoNamedRequired({required int nr, required bool nr2}) =>
      _$withTwoNamedRequiredEvent.add((nr: nr, nr2: nr2));

  @override
  void withAnnotationAndPositional(int pp) =>
      _$withAnnotationAndPositionalEvent.add(pp);

  @override
  void withAnnotationAnd2Positional(int pp1, int pp2) =>
      _$withAnnotationAnd2PositionalEvent.add((pp1: pp1, pp2: pp2));

  @override
  void withSeededPositionalAndOptional(int pp, [int? op]) =>
      _$withSeededPositionalAndOptionalEvent.add((pp: pp, op: op));

  @override
  void withSeededTwoPositionalOptionalDefaultNull([int? p1, int? p2]) =>
      _$withSeededTwoPositionalOptionalDefaultNullEvent.add((p1: p1, p2: p2));

  @override
  void withSeededTwoPositionalOptional([int? p1, int? p2]) =>
      _$withSeededTwoPositionalOptionalEvent.add((p1: p1, p2: p2));

  @override
  void withSeededPositionalEnum(TestEnumParam op) =>
      _$withSeededPositionalEnumEvent.add(op);

  @override
  void withSeeded2PositionalEnum(int pp1, TestEnumParam pp2) =>
      _$withSeeded2PositionalEnumEvent.add((pp1: pp1, pp2: pp2));

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
    _compositeSubscription.dispose();
    super.dispose();
  }
}

// ignore: unused_element
typedef _WithPositionalAndOptionalEventArgs = ({int pp, int? op});

// ignore: unused_element
typedef _WithPositionalAndNamedEventArgs = ({int pp, int np});

// ignore: unused_element
typedef _WithPositionalAndOptionalDefaultParamEventArgs = ({int pp, int op});

// ignore: unused_element
typedef _WithPositionalAndNamedDefaultParamEventArgs = ({int pp, int np});

// ignore: unused_element
typedef _With2PositionalEventArgs = ({int pp1, int pp2});

// ignore: unused_element
typedef _With2OptionalEventArgs = ({int? op1, int? op2});

// ignore: unused_element
typedef _With2NamedEventArgs = ({int np1, int np2});

// ignore: unused_element
typedef _With2OptionalDefaultEventArgs = ({int op1, int op2});

// ignore: unused_element
typedef _With2NamedDefaultEventArgs = ({int np1, int np2});

// ignore: unused_element
typedef _With2PositionalAndOptionalEventArgs = ({int pp1, int pp2, int? op1});

// ignore: unused_element
typedef _With2PositionalAndNamedEventArgs = ({int pp1, int pp2, int np1});

// ignore: unused_element
typedef _WithPositionalAnd2OptionalEventArgs = ({int pp, int? op1, int? op2});

// ignore: unused_element
typedef _WithPositionalAnd2NamedEventArgs = ({int pp, int? np1, int? np2});

// ignore: unused_element
typedef _WithPositionalAnd1Named1RequiredEventArgs =
    ({int pp, int? np1, int np2});

// ignore: unused_element
typedef _WithTwoNamedRequiredEventArgs = ({int nr, bool nr2});

// ignore: unused_element
typedef _WithAnnotationAnd2PositionalEventArgs = ({int pp1, int pp2});

// ignore: unused_element
typedef _WithSeededPositionalAndOptionalEventArgs = ({int pp, int? op});

// ignore: unused_element
typedef _WithSeededTwoPositionalOptionalDefaultNullEventArgs =
    ({int? p1, int? p2});

// ignore: unused_element
typedef _WithSeededTwoPositionalOptionalEventArgs = ({int? p1, int? p2});

// ignore: unused_element
typedef _WithSeeded2PositionalEnumEventArgs = ({int pp1, TestEnumParam pp2});
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
    seed: (pp1: 1, pp2: 2),
  )
  void withAnnotationAnd2Positional(int pp1, int pp2);

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: (pp: 1, op: 2),
  )
  void withSeededPositionalAndOptional(int pp, [int? op]);

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: (p1: null, p2: null),
  )
  void withSeededTwoPositionalOptionalDefaultNull([int? p1, int? p2]);

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: (p1: 0, p2: 1),
  )
  void withSeededTwoPositionalOptional([int? p1, int? p2]);

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: TestEnumParam.seed,
  )
  void withSeededPositionalEnum(TestEnumParam op);

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: (pp1: 1, pp2: TestEnumParam.seed),
  )
  void withSeeded2PositionalEnum(int pp1, TestEnumParam pp2);
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  @RxBlocIgnoreState()
  Stream<bool> get isIgnored;

  Stream<bool> get isNotIgnored;
}
