// Mocks generated by Mockito 5.4.2 from annotations
// in rx_bloc_favorites_advanced/test/feature_puppy/search/blocs/puppy_list_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:favorites_advanced_base/models.dart' as _i4;
import 'package:image_picker/image_picker.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart'
    as _i2;
import 'package:rx_bloc_favorites_advanced/base/repositories/paginated_puppies_repository.dart'
    as _i6;
import 'package:rx_bloc_list/models.dart' as _i3;

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

class _FakeCoordinatorEvents_0 extends _i1.SmartFake
    implements _i2.CoordinatorEvents {
  _FakeCoordinatorEvents_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCoordinatorStates_1 extends _i1.SmartFake
    implements _i2.CoordinatorStates {
  _FakeCoordinatorStates_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePaginatedList_2<E> extends _i1.SmartFake
    implements _i3.PaginatedList<E> {
  _FakePaginatedList_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePuppy_3 extends _i1.SmartFake implements _i4.Puppy {
  _FakePuppy_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CoordinatorEvents].
///
/// See the documentation for Mockito's code generation for more information.
class MockCoordinatorEvents extends _i1.Mock implements _i2.CoordinatorEvents {
  MockCoordinatorEvents() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void puppyUpdated(_i4.Puppy? puppy) => super.noSuchMethod(
        Invocation.method(
          #puppyUpdated,
          [puppy],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void puppiesWithExtraDetailsFetched(List<_i4.Puppy>? puppies) =>
      super.noSuchMethod(
        Invocation.method(
          #puppiesWithExtraDetailsFetched,
          [puppies],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [CoordinatorStates].
///
/// See the documentation for Mockito's code generation for more information.
class MockCoordinatorStates extends _i1.Mock implements _i2.CoordinatorStates {
  MockCoordinatorStates() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Stream<_i4.Puppy> get onPuppyUpdated => (super.noSuchMethod(
        Invocation.getter(#onPuppyUpdated),
        returnValue: _i5.Stream<_i4.Puppy>.empty(),
      ) as _i5.Stream<_i4.Puppy>);
  @override
  _i5.Stream<List<_i4.Puppy>> get onFetchedPuppiesWithExtraDetails =>
      (super.noSuchMethod(
        Invocation.getter(#onFetchedPuppiesWithExtraDetails),
        returnValue: _i5.Stream<List<_i4.Puppy>>.empty(),
      ) as _i5.Stream<List<_i4.Puppy>>);
  @override
  _i5.Stream<List<_i4.Puppy>> get onPuppiesUpdated => (super.noSuchMethod(
        Invocation.getter(#onPuppiesUpdated),
        returnValue: _i5.Stream<List<_i4.Puppy>>.empty(),
      ) as _i5.Stream<List<_i4.Puppy>>);
}

/// A class which mocks [CoordinatorBlocType].
///
/// See the documentation for Mockito's code generation for more information.
class MockCoordinatorBlocType extends _i1.Mock
    implements _i2.CoordinatorBlocType {
  MockCoordinatorBlocType() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CoordinatorEvents get events => (super.noSuchMethod(
        Invocation.getter(#events),
        returnValue: _FakeCoordinatorEvents_0(
          this,
          Invocation.getter(#events),
        ),
      ) as _i2.CoordinatorEvents);
  @override
  _i2.CoordinatorStates get states => (super.noSuchMethod(
        Invocation.getter(#states),
        returnValue: _FakeCoordinatorStates_1(
          this,
          Invocation.getter(#states),
        ),
      ) as _i2.CoordinatorStates);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [PaginatedPuppiesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPaginatedPuppiesRepository extends _i1.Mock
    implements _i6.PaginatedPuppiesRepository {
  MockPaginatedPuppiesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i3.PaginatedList<_i4.Puppy>> getFavoritePuppiesPaginated({
    required int? pageSize,
    required int? page,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFavoritePuppiesPaginated,
          [],
          {
            #pageSize: pageSize,
            #page: page,
          },
        ),
        returnValue: _i5.Future<_i3.PaginatedList<_i4.Puppy>>.value(
            _FakePaginatedList_2<_i4.Puppy>(
          this,
          Invocation.method(
            #getFavoritePuppiesPaginated,
            [],
            {
              #pageSize: pageSize,
              #page: page,
            },
          ),
        )),
      ) as _i5.Future<_i3.PaginatedList<_i4.Puppy>>);
  @override
  _i5.Future<_i3.PaginatedList<_i4.Puppy>> getPuppiesPaginated({
    required String? query,
    required int? pageSize,
    required int? page,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPuppiesPaginated,
          [],
          {
            #query: query,
            #pageSize: pageSize,
            #page: page,
          },
        ),
        returnValue: _i5.Future<_i3.PaginatedList<_i4.Puppy>>.value(
            _FakePaginatedList_2<_i4.Puppy>(
          this,
          Invocation.method(
            #getPuppiesPaginated,
            [],
            {
              #query: query,
              #pageSize: pageSize,
              #page: page,
            },
          ),
        )),
      ) as _i5.Future<_i3.PaginatedList<_i4.Puppy>>);
  @override
  _i5.Future<List<_i4.Puppy>> getFavoritePuppies() => (super.noSuchMethod(
        Invocation.method(
          #getFavoritePuppies,
          [],
        ),
        returnValue: _i5.Future<List<_i4.Puppy>>.value(<_i4.Puppy>[]),
      ) as _i5.Future<List<_i4.Puppy>>);
  @override
  _i5.Future<List<_i4.Puppy>> getPuppies({String? query = r''}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPuppies,
          [],
          {#query: query},
        ),
        returnValue: _i5.Future<List<_i4.Puppy>>.value(<_i4.Puppy>[]),
      ) as _i5.Future<List<_i4.Puppy>>);
  @override
  _i5.Future<_i4.Puppy> favoritePuppy(
    _i4.Puppy? puppy, {
    required bool? isFavorite,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #favoritePuppy,
          [puppy],
          {#isFavorite: isFavorite},
        ),
        returnValue: _i5.Future<_i4.Puppy>.value(_FakePuppy_3(
          this,
          Invocation.method(
            #favoritePuppy,
            [puppy],
            {#isFavorite: isFavorite},
          ),
        )),
      ) as _i5.Future<_i4.Puppy>);
  @override
  _i5.Future<List<_i4.Puppy>> fetchFullEntities(List<String>? ids) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchFullEntities,
          [ids],
        ),
        returnValue: _i5.Future<List<_i4.Puppy>>.value(<_i4.Puppy>[]),
      ) as _i5.Future<List<_i4.Puppy>>);
  @override
  _i5.Future<_i7.XFile?> pickPuppyImage(_i4.ImagePickerAction? source) =>
      (super.noSuchMethod(
        Invocation.method(
          #pickPuppyImage,
          [source],
        ),
        returnValue: _i5.Future<_i7.XFile?>.value(),
      ) as _i5.Future<_i7.XFile?>);
  @override
  _i5.Future<_i4.Puppy> updatePuppy(
    String? puppyId,
    _i4.Puppy? newValue,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatePuppy,
          [
            puppyId,
            newValue,
          ],
        ),
        returnValue: _i5.Future<_i4.Puppy>.value(_FakePuppy_3(
          this,
          Invocation.method(
            #updatePuppy,
            [
              puppyId,
              newValue,
            ],
          ),
        )),
      ) as _i5.Future<_i4.Puppy>);
}
