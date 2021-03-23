// Mocks generated by Mockito 5.0.0 from annotations
// in rx_bloc_favorites_advanced/test/feature_puppy/search/blocs/puppy_list_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:favorites_advanced_base/src/models/puppy.dart' as _i3;
import 'package:favorites_advanced_base/src/repositories/puppies_repository.dart'
    as _i6;
import 'package:favorites_advanced_base/src/utils/enums.dart' as _i7;
import 'package:image_picker_platform_interface/src/types/picked_file/picked_file.dart'
    as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart'
    as _i2;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

class _FakeCoordinatorEvents extends _i1.Fake implements _i2.CoordinatorEvents {
}

class _FakeCoordinatorStates extends _i1.Fake implements _i2.CoordinatorStates {
}

class _FakeDuration extends _i1.Fake implements Duration {}

class _FakePuppy extends _i1.Fake implements _i3.Puppy {}

class _FakePickedFile extends _i1.Fake implements _i4.PickedFile {}

/// A class which mocks [CoordinatorEvents].
///
/// See the documentation for Mockito's code generation for more information.
class MockCoordinatorEvents extends _i1.Mock implements _i2.CoordinatorEvents {
  MockCoordinatorEvents() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void puppyUpdated(_i3.Puppy? puppy) =>
      super.noSuchMethod(Invocation.method(#puppyUpdated, [puppy]),
          returnValueForMissingStub: null);
  @override
  void puppiesWithExtraDetailsFetched(List<_i3.Puppy>? puppies) =>
      super.noSuchMethod(
          Invocation.method(#puppiesWithExtraDetailsFetched, [puppies]),
          returnValueForMissingStub: null);
}

/// A class which mocks [CoordinatorStates].
///
/// See the documentation for Mockito's code generation for more information.
class MockCoordinatorStates extends _i1.Mock implements _i2.CoordinatorStates {
  MockCoordinatorStates() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Stream<_i3.Puppy> get onPuppyUpdated =>
      (super.noSuchMethod(Invocation.getter(#onPuppyUpdated),
          returnValue: Stream<_i3.Puppy>.empty()) as _i5.Stream<_i3.Puppy>);
  @override
  _i5.Stream<List<_i3.Puppy>> get onFetchedPuppiesWithExtraDetails =>
      (super.noSuchMethod(Invocation.getter(#onFetchedPuppiesWithExtraDetails),
              returnValue: Stream<List<_i3.Puppy>>.empty())
          as _i5.Stream<List<_i3.Puppy>>);
  @override
  _i5.Stream<List<_i3.Puppy>> get onPuppiesUpdated =>
      (super.noSuchMethod(Invocation.getter(#onPuppiesUpdated),
              returnValue: Stream<List<_i3.Puppy>>.empty())
          as _i5.Stream<List<_i3.Puppy>>);
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
  _i2.CoordinatorEvents get events =>
      (super.noSuchMethod(Invocation.getter(#events),
          returnValue: _FakeCoordinatorEvents()) as _i2.CoordinatorEvents);
  @override
  _i2.CoordinatorStates get states =>
      (super.noSuchMethod(Invocation.getter(#states),
          returnValue: _FakeCoordinatorStates()) as _i2.CoordinatorStates);
}

/// A class which mocks [PuppiesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPuppiesRepository extends _i1.Mock implements _i6.PuppiesRepository {
  MockPuppiesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Duration get artificialDelay =>
      (super.noSuchMethod(Invocation.getter(#artificialDelay),
          returnValue: _FakeDuration()) as Duration);
  @override
  List<_i3.Puppy> get puppies => (super
          .noSuchMethod(Invocation.getter(#puppies), returnValue: <_i3.Puppy>[])
      as List<_i3.Puppy>);
  @override
  set puppies(List<_i3.Puppy>? _puppies) =>
      super.noSuchMethod(Invocation.setter(#puppies, _puppies),
          returnValueForMissingStub: null);
  @override
  _i5.Future<List<_i3.Puppy>> getPuppies({String? query = r''}) =>
      (super.noSuchMethod(Invocation.method(#getPuppies, [], {#query: query}),
              returnValue: Future.value(<_i3.Puppy>[]))
          as _i5.Future<List<_i3.Puppy>>);
  @override
  _i5.Future<List<_i3.Puppy>> getFavoritePuppies() => (super.noSuchMethod(
      Invocation.method(#getFavoritePuppies, []),
      returnValue: Future.value(<_i3.Puppy>[])) as _i5.Future<List<_i3.Puppy>>);
  @override
  _i5.Future<_i3.Puppy> favoritePuppy(_i3.Puppy? puppy, {bool? isFavorite}) =>
      (super.noSuchMethod(
          Invocation.method(#favoritePuppy, [puppy], {#isFavorite: isFavorite}),
          returnValue: Future.value(_FakePuppy())) as _i5.Future<_i3.Puppy>);
  @override
  _i5.Future<List<_i3.Puppy>> fetchFullEntities(List<String>? ids) =>
      (super.noSuchMethod(Invocation.method(#fetchFullEntities, [ids]),
              returnValue: Future.value(<_i3.Puppy>[]))
          as _i5.Future<List<_i3.Puppy>>);
  @override
  _i5.Future<_i3.Puppy> updatePuppy(String? puppyId, _i3.Puppy? newValue) =>
      (super.noSuchMethod(Invocation.method(#updatePuppy, [puppyId, newValue]),
          returnValue: Future.value(_FakePuppy())) as _i5.Future<_i3.Puppy>);
  @override
  _i5.Future<_i4.PickedFile?> pickPuppyImage(_i7.ImagePickerAction? source) =>
      (super.noSuchMethod(Invocation.method(#pickPuppyImage, [source]),
              returnValue: Future.value(_FakePickedFile()))
          as _i5.Future<_i4.PickedFile?>);
}
