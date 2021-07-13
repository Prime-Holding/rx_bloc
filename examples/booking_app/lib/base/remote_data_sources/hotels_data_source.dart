import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc_list/models.dart';

abstract class HotelsDataSource {
  Future<PaginatedList<Hotel>> getHotels({
    required int page,
    required int pageSize,
    HotelSearchFilters? filters,
  });

  Future<List<Hotel>> getFavoriteHotels();

  Future<Hotel> favoriteHotel(
    Hotel hotel, {
    required bool isFavorite,
  });

  Future<List<HotelExtraDetails>> fetchExtraDetails(List<String> ids);

  Future<HotelFullExtraDetails> fetchFullExtraDetails(String hotelId);

  Future<void> seed();
}
