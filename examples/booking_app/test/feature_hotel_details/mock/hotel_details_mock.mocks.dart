// Mocks generated by Mockito 5.4.4 from annotations
// in booking_app/test/feature_hotel_details/mock/hotel_details_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:booking_app/feature_hotel_details/blocs/hotel_details_bloc.dart'
    as _i2;
import 'package:favorites_advanced_base/core.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeHotelDetailsBlocEvents_0 extends _i1.SmartFake
    implements _i2.HotelDetailsBlocEvents {
  _FakeHotelDetailsBlocEvents_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeHotelDetailsBlocStates_1 extends _i1.SmartFake
    implements _i2.HotelDetailsBlocStates {
  _FakeHotelDetailsBlocStates_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [HotelDetailsBlocStates].
///
/// See the documentation for Mockito's code generation for more information.
class MockHotelDetailsBlocStates extends _i1.Mock
    implements _i2.HotelDetailsBlocStates {
  MockHotelDetailsBlocStates() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.Hotel> get hotel => (super.noSuchMethod(
        Invocation.getter(#hotel),
        returnValue: _i3.Stream<_i4.Hotel>.empty(),
      ) as _i3.Stream<_i4.Hotel>);
}

/// A class which mocks [HotelDetailsBlocEvents].
///
/// See the documentation for Mockito's code generation for more information.
class MockHotelDetailsBlocEvents extends _i1.Mock
    implements _i2.HotelDetailsBlocEvents {
  MockHotelDetailsBlocEvents() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [HotelDetailsBlocType].
///
/// See the documentation for Mockito's code generation for more information.
class MockHotelDetailsBlocType extends _i1.Mock
    implements _i2.HotelDetailsBlocType {
  MockHotelDetailsBlocType() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.HotelDetailsBlocEvents get events => (super.noSuchMethod(
        Invocation.getter(#events),
        returnValue: _FakeHotelDetailsBlocEvents_0(
          this,
          Invocation.getter(#events),
        ),
      ) as _i2.HotelDetailsBlocEvents);

  @override
  _i2.HotelDetailsBlocStates get states => (super.noSuchMethod(
        Invocation.getter(#states),
        returnValue: _FakeHotelDetailsBlocStates_1(
          this,
          Invocation.getter(#states),
        ),
      ) as _i2.HotelDetailsBlocStates);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
