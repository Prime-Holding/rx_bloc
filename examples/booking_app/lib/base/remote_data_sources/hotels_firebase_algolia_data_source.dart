import 'dart:collection';

import 'package:booking_app/base/remote_data_sources/hotels_firebase_data_source.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc_list/models.dart';

class HotelsFirebaseAlgoliaDataSource extends HotelsFirebaseDataSource {
  @override
  Future<PaginatedList<Hotel>> getHotels({
    required int page,
    required int pageSize,
    HotelSearchFilters? filters,
  }) async {
    // Use whe you want to simulate locally
    // FirebaseFunctions.instance
    //     .useFunctionsEmulator(origin: 'http://localhost:5001');

    final queryString = getQueryString(page, pageSize, filters);
    final callable =
        FirebaseFunctions.instance.httpsCallable('getHotels$queryString');
    final results = await callable();

    final hotels = results.data['records']
        .map<Hotel>((json) => Hotel.fromJson(HashMap.from(json)))
        .toList();

    return PaginatedList(
      list: hotels,
      pageSize: pageSize,
      totalCount: results.data['totalRecords'],
    );
  }

  String getQueryString(int page, int pageSize, HotelSearchFilters? filters) {
    final qParams = <String, dynamic>{};

    qParams['page'] = page;
    qParams['page_size'] = pageSize;

    if (filters?.query != null && filters!.query.isNotEmpty) {
      qParams['search'] = filters.query;
    }

    // If there are any other filters, apply them
    if (filters?.advancedFiltersOn ?? false) {
      if (filters!.dateRange != null) {
        final startAtTimestamp =
            filters.dateRange!.start.microsecondsSinceEpoch;
        final endAtTimestamp = filters.dateRange!.end.microsecondsSinceEpoch;
        qParams['start_at_timestamp'] = startAtTimestamp;
        qParams['end_at_timestamp'] = endAtTimestamp;
      }

      if (filters.roomCapacity > 0) {
        qParams['room_capacity'] = filters.roomCapacity;
      }

      if (filters.personCapacity > 0) {
        qParams['person_capacity'] = filters.personCapacity;
      }
    }

    if (filters!.sortBy != SortBy.none) {
      if (filters.sortBy == SortBy.priceAsc) {
        qParams['sort_by'] = 'perNight';
        qParams['order'] = 'asc';
      }

      if (filters.sortBy == SortBy.priceDesc) {
        qParams['sort_by'] = 'perNight';
        qParams['order'] = 'desc';
      }

      if (filters.sortBy == SortBy.distanceAsc) {
        qParams['sort_by'] = 'dist';
        qParams['order'] = 'asc';
      }

      if (filters.sortBy == SortBy.distanceDesc) {
        qParams['sort_by'] = 'dist';
        qParams['order'] = 'desc';
      }
    }

    if (qParams.isEmpty) {
      return '';
    }

    var queryString = '';
    qParams.keys.toList().asMap().forEach((index, value) {
      queryString += index == 0 ? '?' : '&';
      queryString += '$value=${qParams[value]}';
    });

    return queryString;
  }
}
