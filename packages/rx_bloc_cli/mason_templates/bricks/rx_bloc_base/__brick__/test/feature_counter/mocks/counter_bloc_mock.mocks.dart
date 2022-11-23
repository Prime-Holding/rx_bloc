// Mocks generated by Mockito 5.3.2 from annotations
// in test_app/test/feature_counter/mocks/counter_bloc_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:rx_bloc/rx_bloc.dart' as _i4;
import 'package:test_app/base/models/errors/error_model.dart' as _i5;
import 'package:test_app/feature_counter/blocs/counter_bloc.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCounterBlocEvents_0 extends _i1.SmartFake
    implements _i2.CounterBlocEvents {
  _FakeCounterBlocEvents_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCounterBlocStates_1 extends _i1.SmartFake
    implements _i2.CounterBlocStates {
  _FakeCounterBlocStates_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CounterBlocEvents].
///
/// See the documentation for Mockito's code generation for more information.
class MockCounterBlocEvents extends _i1.Mock implements _i2.CounterBlocEvents {
  MockCounterBlocEvents() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void increment() => super.noSuchMethod(
        Invocation.method(
          #increment,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void decrement() => super.noSuchMethod(
        Invocation.method(
          #decrement,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void reload() => super.noSuchMethod(
        Invocation.method(
          #reload,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [CounterBlocStates].
///
/// See the documentation for Mockito's code generation for more information.
class MockCounterBlocStates extends _i1.Mock implements _i2.CounterBlocStates {
  MockCounterBlocStates() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.LoadingWithTag> get isLoading => (super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: _i3.Stream<_i4.LoadingWithTag>.empty(),
      ) as _i3.Stream<_i4.LoadingWithTag>);
  @override
  _i3.Stream<_i5.ErrorModel> get errors => (super.noSuchMethod(
        Invocation.getter(#errors),
        returnValue: _i3.Stream<_i5.ErrorModel>.empty(),
      ) as _i3.Stream<_i5.ErrorModel>);
  @override
  _i3.Stream<int> get count => (super.noSuchMethod(
        Invocation.getter(#count),
        returnValue: _i3.Stream<int>.empty(),
      ) as _i3.Stream<int>);
}

/// A class which mocks [CounterBlocType].
///
/// See the documentation for Mockito's code generation for more information.
class MockCounterBlocType extends _i1.Mock implements _i2.CounterBlocType {
  MockCounterBlocType() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CounterBlocEvents get events => (super.noSuchMethod(
        Invocation.getter(#events),
        returnValue: _FakeCounterBlocEvents_0(
          this,
          Invocation.getter(#events),
        ),
      ) as _i2.CounterBlocEvents);
  @override
  _i2.CounterBlocStates get states => (super.noSuchMethod(
        Invocation.getter(#states),
        returnValue: _FakeCounterBlocStates_1(
          this,
          Invocation.getter(#states),
        ),
      ) as _i2.CounterBlocStates);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
