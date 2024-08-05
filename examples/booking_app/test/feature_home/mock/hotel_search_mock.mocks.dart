// Mocks generated by Mockito 5.4.4 from annotations
// in booking_app/test/feature_home/mock/hotel_search_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:booking_app/feature_hotel_search/blocs/hotel_search_bloc.dart'
    as _i2;
import 'package:booking_app/feature_hotel_search/models/capacity_filter_data.dart'
    as _i7;
import 'package:booking_app/feature_hotel_search/models/date_range_filter_data.dart'
    as _i6;
import 'package:favorites_advanced_base/core.dart' as _i5;
import 'package:flutter/material.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:rx_bloc_list/rx_bloc_list.dart' as _i4;

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

class _FakeHotelSearchBlocEvents_0 extends _i1.SmartFake
    implements _i2.HotelSearchBlocEvents {
  _FakeHotelSearchBlocEvents_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeHotelSearchBlocStates_1 extends _i1.SmartFake
    implements _i2.HotelSearchBlocStates {
  _FakeHotelSearchBlocStates_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [HotelSearchBlocStates].
///
/// See the documentation for Mockito's code generation for more information.
class MockHotelSearchBlocStates extends _i1.Mock
    implements _i2.HotelSearchBlocStates {
  MockHotelSearchBlocStates() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.PaginatedList<_i5.Hotel>> get hotels => (super.noSuchMethod(
        Invocation.getter(#hotels),
        returnValue: _i3.Stream<_i4.PaginatedList<_i5.Hotel>>.empty(),
      ) as _i3.Stream<_i4.PaginatedList<_i5.Hotel>>);

  @override
  _i3.Stream<String> get hotelsFound => (super.noSuchMethod(
        Invocation.getter(#hotelsFound),
        returnValue: _i3.Stream<String>.empty(),
      ) as _i3.Stream<String>);

  @override
  _i3.Stream<String> get queryFilter => (super.noSuchMethod(
        Invocation.getter(#queryFilter),
        returnValue: _i3.Stream<String>.empty(),
      ) as _i3.Stream<String>);

  @override
  _i3.Stream<_i6.DateRangeFilterData> get dateRangeFilterData =>
      (super.noSuchMethod(
        Invocation.getter(#dateRangeFilterData),
        returnValue: _i3.Stream<_i6.DateRangeFilterData>.empty(),
      ) as _i3.Stream<_i6.DateRangeFilterData>);

  @override
  _i3.Stream<_i7.CapacityFilterData> get capacityFilterData =>
      (super.noSuchMethod(
        Invocation.getter(#capacityFilterData),
        returnValue: _i3.Stream<_i7.CapacityFilterData>.empty(),
      ) as _i3.Stream<_i7.CapacityFilterData>);

  @override
  _i3.Stream<_i5.SortBy> get sortedBy => (super.noSuchMethod(
        Invocation.getter(#sortedBy),
        returnValue: _i3.Stream<_i5.SortBy>.empty(),
      ) as _i3.Stream<_i5.SortBy>);

  @override
  _i3.Future<void> get refreshDone => (super.noSuchMethod(
        Invocation.getter(#refreshDone),
        returnValue: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [HotelSearchBlocEvents].
///
/// See the documentation for Mockito's code generation for more information.
class MockHotelSearchBlocEvents extends _i1.Mock
    implements _i2.HotelSearchBlocEvents {
  MockHotelSearchBlocEvents() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void filterByQuery(String? query) => super.noSuchMethod(
        Invocation.method(
          #filterByQuery,
          [query],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void filterByDateRange({_i8.DateTimeRange? dateRange}) => super.noSuchMethod(
        Invocation.method(
          #filterByDateRange,
          [],
          {#dateRange: dateRange},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void filterByCapacity({
    int? roomCapacity = 0,
    int? personCapacity = 0,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #filterByCapacity,
          [],
          {
            #roomCapacity: roomCapacity,
            #personCapacity: personCapacity,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void sortBy({_i5.SortBy? sort = _i5.SortBy.none}) => super.noSuchMethod(
        Invocation.method(
          #sortBy,
          [],
          {#sort: sort},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void reload({
    required bool? reset,
    bool? fullReset = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #reload,
          [],
          {
            #reset: reset,
            #fullReset: fullReset,
          },
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [HotelSearchBlocType].
///
/// See the documentation for Mockito's code generation for more information.
class MockHotelSearchBlocType extends _i1.Mock
    implements _i2.HotelSearchBlocType {
  MockHotelSearchBlocType() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.HotelSearchBlocEvents get events => (super.noSuchMethod(
        Invocation.getter(#events),
        returnValue: _FakeHotelSearchBlocEvents_0(
          this,
          Invocation.getter(#events),
        ),
      ) as _i2.HotelSearchBlocEvents);

  @override
  _i2.HotelSearchBlocStates get states => (super.noSuchMethod(
        Invocation.getter(#states),
        returnValue: _FakeHotelSearchBlocStates_1(
          this,
          Invocation.getter(#states),
        ),
      ) as _i2.HotelSearchBlocStates);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
