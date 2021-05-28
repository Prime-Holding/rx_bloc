import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/src/models/hotel_search_filters.dart';
import 'package:flutter/material.dart';

import '../models/hotel.dart';

class HotelsRepository {
  HotelsRepository({
    required HotelsDataSource hotelsDataSource,
  }) : _hotelsDataSource = hotelsDataSource;

  final HotelsDataSource _hotelsDataSource;

  Future<List<Hotel>> getHotels({HotelSearchFilters? filters}) async {
    List<Hotel> hotels = await _hotelsDataSource.getHotels(filters: filters);

    // If there are any other filters, apply them
    if (filters?.advancedFiltersOn ?? false) {
      hotels = hotels
          .where((hotel) => hotel.filtersApply(
                range: filters!.dateRange,
                rooms: filters.roomCapacity,
                persons: filters.personCapacity,
              ))
          .toList();
    }

    // Sort items before returning
    hotels = _sortHotels(hotels, filters?.sortBy ?? SortBy.none);

    final query = filters?.query ?? '';
    if (query == '') {
      return hotels;
    }

    return hotels
        .where(
            (hotel) => hotel.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Hotel>> getFavoriteHotels() =>
      _hotelsDataSource.getFavoriteHotels();

  Future<Hotel> favoriteHotel(
    Hotel hotel, {
    required bool isFavorite,
  }) =>
      _hotelsDataSource.favoriteHotel(hotel, isFavorite: isFavorite);

  Future<List<HotelExtraDetails>> fetchExtraDetails(List<String> ids) =>
      _hotelsDataSource.fetchExtraDetails(ids);

  Future<HotelFullExtraDetails> fetchFullExtraDetails(String hotelId) =>
      _hotelsDataSource.fetchFullExtraDetails(hotelId);
}

extension _HotelExtensions on Hotel {
  /// Performs a check whether the provided filters apply for the current hotel.
  bool filtersApply(
          {required DateTimeRange? range,
          required int rooms,
          required int persons}) =>
      _withinWorkRange(range) &&
      _hasEnoughRooms(rooms) &&
      _hasPlaceForPeople(persons);

  /// Does the current hotel work within the current date range?
  bool _withinWorkRange(DateTimeRange? range) => range != null
      ? (startWorkDate.isBefore(range.start) && endWorkDate.isAfter(range.end))
      : true;

  /// Has the current hotel enough rooms?
  bool _hasEnoughRooms(int rooms) => rooms > 0 ? roomCapacity > rooms : true;

  /// Can the hotel accommodate a select number of persons?
  bool _hasPlaceForPeople(int persons) =>
      persons > 0 ? personCapacity > persons : true;
}

List<Hotel> _sortHotels(List<Hotel> hotels, SortBy sortType) {
// Sort by price
  if (sortType == SortBy.priceAsc || sortType == SortBy.priceDesc) {
    final desc = sortType == SortBy.priceDesc;
    hotels.sort(
      (h1, h2) => desc
          ? h2.perNight.compareTo(h1.perNight)
          : h1.perNight.compareTo(h2.perNight),
    );
  }

// Sort by distance
//   if (sortType == SortBy.distanceAsc || sortType == SortBy.distanceDesc) {
//     final desc = sortType == SortBy.distanceDesc;
//     hotels.sort(
//       (h1, h2) =>
//           desc ? h1.dist.compareTo(h2.dist) : h2.dist.compareTo(h1.dist),
//     );
//   }

  return hotels;
}
