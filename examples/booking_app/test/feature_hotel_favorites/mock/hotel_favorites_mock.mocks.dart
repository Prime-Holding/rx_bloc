// Mocks generated by Mockito 5.4.2 from annotations
// in booking_app/test/feature_hotel_favorites/mock/hotel_favorites_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:booking_app/feature_hotel_favorites/blocs/hotel_favorites_bloc.dart'
    as _i2;
import 'package:favorites_advanced_base/models.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:rx_bloc/rx_bloc.dart' as _i4;

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

class _FakeHotelFavoritesBlocEvents_0 extends _i1.SmartFake
    implements _i2.HotelFavoritesBlocEvents {
  _FakeHotelFavoritesBlocEvents_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeHotelFavoritesBlocStates_1 extends _i1.SmartFake
    implements _i2.HotelFavoritesBlocStates {
  _FakeHotelFavoritesBlocStates_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [HotelFavoritesBlocStates].
///
/// See the documentation for Mockito's code generation for more information.
class MockHotelFavoritesBlocStates extends _i1.Mock
    implements _i2.HotelFavoritesBlocStates {
  MockHotelFavoritesBlocStates() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.Result<List<_i5.Hotel>>> get favoriteHotels =>
      (super.noSuchMethod(
        Invocation.getter(#favoriteHotels),
        returnValue: _i3.Stream<_i4.Result<List<_i5.Hotel>>>.empty(),
      ) as _i3.Stream<_i4.Result<List<_i5.Hotel>>>);
  @override
  _i3.Stream<int> get count => (super.noSuchMethod(
        Invocation.getter(#count),
        returnValue: _i3.Stream<int>.empty(),
      ) as _i3.Stream<int>);
}

/// A class which mocks [HotelFavoritesBlocEvents].
///
/// See the documentation for Mockito's code generation for more information.
class MockHotelFavoritesBlocEvents extends _i1.Mock
    implements _i2.HotelFavoritesBlocEvents {
  MockHotelFavoritesBlocEvents() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void reloadFavoriteHotels({required bool? silently}) => super.noSuchMethod(
        Invocation.method(
          #reloadFavoriteHotels,
          [],
          {#silently: silently},
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [HotelFavoritesBlocType].
///
/// See the documentation for Mockito's code generation for more information.
class MockHotelFavoritesBlocType extends _i1.Mock
    implements _i2.HotelFavoritesBlocType {
  MockHotelFavoritesBlocType() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.HotelFavoritesBlocEvents get events => (super.noSuchMethod(
        Invocation.getter(#events),
        returnValue: _FakeHotelFavoritesBlocEvents_0(
          this,
          Invocation.getter(#events),
        ),
      ) as _i2.HotelFavoritesBlocEvents);
  @override
  _i2.HotelFavoritesBlocStates get states => (super.noSuchMethod(
        Invocation.getter(#states),
        returnValue: _FakeHotelFavoritesBlocStates_1(
          this,
          Invocation.getter(#states),
        ),
      ) as _i2.HotelFavoritesBlocStates);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
