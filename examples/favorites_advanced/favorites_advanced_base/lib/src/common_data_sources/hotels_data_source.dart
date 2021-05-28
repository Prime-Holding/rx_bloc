import '../../models.dart';

abstract class HotelsDataSource {
  Future<List<Hotel>> getHotels({HotelSearchFilters? filters});

  Future<List<Hotel>> getFavoriteHotels();

  Future<Hotel> favoriteHotel(
    Hotel hotel, {
    required bool isFavorite,
  });

  Future<List<HotelExtraDetails>> fetchExtraDetails(List<String> ids);

  Future<HotelFullExtraDetails> fetchFullExtraDetails(String hotelId);

  Future<void> seed();
}
