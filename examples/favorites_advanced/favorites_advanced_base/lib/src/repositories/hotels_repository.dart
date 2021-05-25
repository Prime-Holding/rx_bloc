import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/src/models/hotel_search_filters.dart';

import '../models/hotel.dart';

class HotelsRepository {
  HotelsRepository({
    required HotelsDataSource hotelsDataSource,
  }) : _hotelsDataSource = hotelsDataSource;

  final HotelsDataSource _hotelsDataSource;

  Future<List<Hotel>> getHotels({HotelSearchFilters? filters}) async =>
      _hotelsDataSource.getHotels(filters: filters);

  Future<List<Hotel>> getFavoriteHotels() async =>
      _hotelsDataSource.getFavoriteHotels();

  Future<Hotel> favoriteHotel(
    Hotel hotel, {
    required bool isFavorite,
  }) async =>
      _hotelsDataSource.favoriteHotel(hotel, isFavorite: isFavorite);

  Future<List<Hotel>> fetchFullEntities(
    List<String> ids, {
    bool allProps = false,
  }) async =>
      _hotelsDataSource.fetchFullEntities(ids, allProps: allProps);
}
