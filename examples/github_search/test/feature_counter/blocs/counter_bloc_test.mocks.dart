// Mocks generated by Mockito 5.3.2 from annotations
// in github_search/test/feature_counter/blocs/counter_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:github_search/base/data_sources/remote/count_remote_data_source.dart'
    as _i2;
import 'package:github_search/base/models/count.dart' as _i3;
import 'package:github_search/base/repositories/counter_repository.dart' as _i4;
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

class _FakeCountRemoteDataSource_0 extends _i1.SmartFake
    implements _i2.CountRemoteDataSource {
  _FakeCountRemoteDataSource_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCount_1 extends _i1.SmartFake implements _i3.Count {
  _FakeCount_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CounterRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockCounterRepository extends _i1.Mock implements _i4.CounterRepository {
  MockCounterRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CountRemoteDataSource get countRemoteDataSource => (super.noSuchMethod(
        Invocation.getter(#countRemoteDataSource),
        returnValue: _FakeCountRemoteDataSource_0(
          this,
          Invocation.getter(#countRemoteDataSource),
        ),
      ) as _i2.CountRemoteDataSource);
  @override
  _i5.Future<_i3.Count> getCurrent() => (super.noSuchMethod(
        Invocation.method(
          #getCurrent,
          [],
        ),
        returnValue: _i5.Future<_i3.Count>.value(_FakeCount_1(
          this,
          Invocation.method(
            #getCurrent,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Count>);
  @override
  _i5.Future<_i3.Count> increment() => (super.noSuchMethod(
        Invocation.method(
          #increment,
          [],
        ),
        returnValue: _i5.Future<_i3.Count>.value(_FakeCount_1(
          this,
          Invocation.method(
            #increment,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Count>);
  @override
  _i5.Future<_i3.Count> decrement() => (super.noSuchMethod(
        Invocation.method(
          #decrement,
          [],
        ),
        returnValue: _i5.Future<_i3.Count>.value(_FakeCount_1(
          this,
          Invocation.method(
            #decrement,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Count>);
}
