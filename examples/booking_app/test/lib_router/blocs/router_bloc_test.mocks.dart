// Mocks generated by Mockito 5.4.2 from annotations
// in booking_app/test/lib_router/blocs/router_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:booking_app/lib_router/router.dart' as _i3;
import 'package:go_router/go_router.dart' as _i2;
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

class _FakeGoRouter_0 extends _i1.SmartFake implements _i2.GoRouter {
  _FakeGoRouter_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AppRouter].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppRouter extends _i1.Mock implements _i3.AppRouter {
  MockAppRouter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GoRouter get router => (super.noSuchMethod(
        Invocation.getter(#router),
        returnValue: _FakeGoRouter_0(
          this,
          Invocation.getter(#router),
        ),
      ) as _i2.GoRouter);
}
