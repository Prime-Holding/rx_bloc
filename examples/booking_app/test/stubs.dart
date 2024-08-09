import 'package:booking_app/feature_hotel_search/models/capacity_filter_data.dart';
import 'package:booking_app/feature_hotel_search/models/date_range_filter_data.dart';
import 'package:booking_app/lib_router/router.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc_list/models.dart';

class Stub {
  static final navigation = NavigationStub();

  static final hotel1 = HotelsRepository.hotelsDB.first;

  static final hotel1Loaded = hotel1.copyWith(
    displayDescription: hotel1.description,
    displayDist: hotel1.dist,
    displayFeatures: hotel1.features,
    displayRating: hotel1.rating,
    displayReviews: hotel1.reviews,
    displaySubtitle: hotel1.subTitle,
  );

  static final hotel1Favorited =
      HotelsRepository.hotelsDB.first.copyWith(isFavorite: true);
  static final hotel2 = HotelsRepository.hotelsDB[1];
  static final hotel3 = HotelsRepository.hotelsDB[2];
  static final hotel4 = HotelsRepository.hotelsDB[3];
  static final hotel5 = HotelsRepository.hotelsDB[4];

  static final paginatedListEmpty = PaginatedList<Hotel>(
    list: [],
    pageSize: 10,
    totalCount: 0,
    isLoading: false,
  );

  static final paginatedListEmptyLoading = PaginatedList<Hotel>(
    list: [],
    pageSize: 10,
    totalCount: 0,
    isLoading: true,
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
    isLoading: false,
  );

  static final paginatedListOneHotelLoading = PaginatedList<Hotel>(
    list: [Stub.hotel1],
    pageSize: 10,
    totalCount: 1,
    isLoading: true,
  );

  static final paginatedListTwoHotels = PaginatedList<Hotel>(
    list: [Stub.hotel2, Stub.hotel3],
    pageSize: 10,
    totalCount: 2,
  );

  static final paginatedListTreeHotels = PaginatedList<Hotel>(
    list: [Stub.hotel1, Stub.hotel2, Stub.hotel3],
    pageSize: 10,
    totalCount: 3,
  );

  static final paginatedListError = PaginatedList<Hotel>(
    list: [],
    error: Exception('No internet connection'),
    pageSize: 10,
    totalCount: 3,
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

  static const homePageRoute = HomeRoutes(NavigationItemType.search);

  static const searchNavItemType = NavigationItemType.search;
  static const favoritesNavItemType = NavigationItemType.favorites;

  static const navBarSelectedItem = NavigationItem(
    type: searchNavItemType,
    isSelected: true,
  );

  static const navBarItemsList = [
    NavigationItem(
      type: favoritesNavItemType,
      isSelected: true,
    ),
    NavigationItem(
      type: searchNavItemType,
      isSelected: false,
    ),
  ];
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
