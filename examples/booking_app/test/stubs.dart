import 'package:booking_app/feature_hotel/search/models/capacity_filter_data.dart';
import 'package:booking_app/feature_hotel/search/models/date_range_filter_data.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc_list/models.dart';

class Stub {
  static final navigation = NavigationStub();

  static final hotel1 = StubDataSource.hotelsDB.first;
  static final hotel1Favorited =
      StubDataSource.hotelsDB.first.copyWith(isFavorite: true);
  static final hotel2 = StubDataSource.hotelsDB[1];
  static final hotel3 = StubDataSource.hotelsDB[2];

  static final paginatedListEmpty = PaginatedList<Hotel>(
    list: [],
    pageSize: 10,
    totalCount: 0,
  );

  static final paginatedListHotelThree = PaginatedList<Hotel>(
    list: [Stub.hotel3],
    pageSize: 10,
    totalCount: 1,
  );

  static final paginatedListHotelThreeAndOne = PaginatedList<Hotel>(
    list: [Stub.hotel3, Stub.hotel1],
    pageSize: 10,
    totalCount: 2,
  );

  static final paginatedListOneFavoriteHotel = PaginatedList<Hotel>(
    list: [Stub.hotel1Favorited],
    pageSize: 10,
    totalCount: 1,
  );

  static final paginatedListOneHotel = PaginatedList<Hotel>(
    list: [Stub.hotel1],
    pageSize: 10,
    totalCount: 1,
  );

  static final paginatedListTwoHotels = PaginatedList<Hotel>(
    list: [Stub.hotel2, Stub.hotel3],
    pageSize: 10,
    totalCount: 2,
  );

  static final paginatedListTreeHotels = PaginatedList<Hotel>(
    list: [Stub.hotel1, Stub.hotel2, Stub.hotel3],
    pageSize: 10,
    totalCount: 2,
  );

  static const one = 1;
  static const two = 2;

  static final dateRange = DateTimeRange(
    start: DateTime.utc(2020, 1),
    end: DateTime.utc(2022, 2),
  );

  static final dateRangeEmptyFilterData = DateRangeFilterData(
    dateRange: null,
    text: 'None',
  );

  static final dateRangeFilterData = DateRangeFilterData(
    dateRange: Stub.dateRange,
    text: '01, Jan - 01, Feb',
  );

  static final capacityFilterDataEmpty =
      CapacityFilterData(persons: 0, rooms: 0, text: 'None');

  static final capacityFilterDataTwoPersonsOneRoom =
      CapacityFilterData(persons: 2, rooms: 1, text: '1 Room - 2 People');

  static const query = 'Dubai';
  static const emptyQuery = '';
}

class NavigationStub {
  final searchTitle = 'Search for Puppies';
  final favoritesTitle = 'Favorites Puppies';

  final searchSelected = const NavigationItem(
    isSelected: true,
    type: NavigationItemType.search,
  );

  final searchNotSelected = const NavigationItem(
    isSelected: false,
    type: NavigationItemType.search,
  );

  final favoritesSelected = const NavigationItem(
    isSelected: true,
    type: NavigationItemType.favorites,
  );

  final favoritesNotSelected = const NavigationItem(
    isSelected: false,
    type: NavigationItemType.favorites,
  );
}
