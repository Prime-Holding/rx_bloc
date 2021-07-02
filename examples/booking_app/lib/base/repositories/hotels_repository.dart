import 'package:booking_app/base/remote_data_sources/hotels_data_source.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rx_bloc_list/models.dart';

class HotelsRepository {
  HotelsRepository({
    required HotelsDataSource hotelsDataSource,
  }) : _hotelsDataSource = hotelsDataSource;

  final HotelsDataSource _hotelsDataSource;

  Future<PaginatedList<Hotel>> getHotels({
    required int page,
    required int pageSize,
    HotelSearchFilters? filters,
  }) =>
      _hotelsDataSource.getHotels(
          filters: filters, page: page, pageSize: pageSize);

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
