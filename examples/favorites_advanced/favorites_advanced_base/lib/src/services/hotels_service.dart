import 'package:favorites_advanced_base/src/local_data_sources/stub_data_source.dart';
import 'package:flutter/material.dart';

import '../../models.dart';

class HotelsService {
  static List<Hotel> applyLocalFilters(
      List<Hotel> hotels, HotelSearchFilters? filters) {
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

  static List<Hotel> generateEntities({required int multiplier}) =>
      List.generate(
              multiplier,
              (index) => [...StubDataSource.hotelsDB]
                  .map(
                    (hotel) => hotel.copyWith(
                      id: '$index-${hotel.id}',
                      isFavorite: false,
                    ),
                  )
                  .toList())
          .expand((element) => element)
          .toList()
          .asMap()
          .entries
          .map<Hotel>(
            (entry) => entry.value
                .copyWith(title: '${entry.key} - ${entry.value.title}'),
          )
          .toList();

  static List<HotelExtraDetails> generateExtraEntries({
    required List<Hotel> hotels,
    required int multiplier,
  }) =>
      List.generate(
              multiplier,
              (index) => [...StubDataSource.hotelsExtraDetailsDB]
                  .map(
                    (hotelExtraDetails) => hotelExtraDetails.copyWith(
                      id: '$index-${hotelExtraDetails.id}',
                    ),
                  )
                  .toList())
          .expand((element) => element)
          .toList()
          .asMap()
          .entries
          .map<HotelExtraDetails>(
            (entry) => entry.value.copyWith(hotelId: hotels[entry.key].id),
          )
          .toList();

  static List<HotelFullExtraDetails> generateFullExtraEntries({
    required List<Hotel> hotels,
    required int multiplier,
  }) =>
      List.generate(
              multiplier,
              (index) => [...StubDataSource.hotelsFullExtraDetailsDB]
                  .map(
                    (hotelFullExtraDetails) => hotelFullExtraDetails.copyWith(
                      id: '$index-${hotelFullExtraDetails.id}',
                    ),
                  )
                  .toList())
          .expand((element) => element)
          .toList()
          .asMap()
          .entries
          .map<HotelFullExtraDetails>(
            (entry) => entry.value.copyWith(hotelId: hotels[entry.key].id),
          )
          .toList();
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
      ? (workingDate.isBefore(range.start) && workingDate.isBefore(range.end))
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

//Sort by distance
  if (sortType == SortBy.distanceAsc || sortType == SortBy.distanceDesc) {
    final desc = sortType == SortBy.distanceDesc;
    hotels.sort(
      (h1, h2) =>
          desc ? h1.dist.compareTo(h2.dist) : h2.dist.compareTo(h1.dist),
    );
  }

  if (sortType == SortBy.none) {
    hotels.sort((h1, h2) => h1.id.toLowerCase().compareTo(h2.id.toLowerCase()));
  }

  return hotels;
}
