// Mocks generated by Mockito 5.4.2 from annotations
// in github_search/test/base/common_blocs/user_account_bloc_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:github_search/base/common_blocs/user_account_bloc.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

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

class _FakeUserAccountBlocEvents_0 extends _i1.SmartFake
    implements _i2.UserAccountBlocEvents {
  _FakeUserAccountBlocEvents_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserAccountBlocStates_1 extends _i1.SmartFake
    implements _i2.UserAccountBlocStates {
  _FakeUserAccountBlocStates_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserAccountBlocEvents].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserAccountBlocEvents extends _i1.Mock
    implements _i2.UserAccountBlocEvents {
  MockUserAccountBlocEvents() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void logout() => super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [UserAccountBlocStates].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserAccountBlocStates extends _i1.Mock
    implements _i2.UserAccountBlocStates {
  MockUserAccountBlocStates() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<bool> get loggedIn => (super.noSuchMethod(
        Invocation.getter(#loggedIn),
        returnValue: _i3.Stream<bool>.empty(),
      ) as _i3.Stream<bool>);
  @override
  _i3.Stream<bool> get isLoading => (super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: _i3.Stream<bool>.empty(),
      ) as _i3.Stream<bool>);
  @override
  _i3.Stream<String> get errors => (super.noSuchMethod(
        Invocation.getter(#errors),
        returnValue: _i3.Stream<String>.empty(),
      ) as _i3.Stream<String>);
}

/// A class which mocks [UserAccountBlocType].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserAccountBlocType extends _i1.Mock
    implements _i2.UserAccountBlocType {
  MockUserAccountBlocType() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserAccountBlocEvents get events => (super.noSuchMethod(
        Invocation.getter(#events),
        returnValue: _FakeUserAccountBlocEvents_0(
          this,
          Invocation.getter(#events),
        ),
      ) as _i2.UserAccountBlocEvents);
  @override
  _i2.UserAccountBlocStates get states => (super.noSuchMethod(
        Invocation.getter(#states),
        returnValue: _FakeUserAccountBlocStates_1(
          this,
          Invocation.getter(#states),
        ),
      ) as _i2.UserAccountBlocStates);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
