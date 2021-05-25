import '../../models.dart';

abstract class HotelsDataSource {
  Future<List<Hotel>> getHotels({HotelSearchFilters? filters});

  Future<List<Hotel>> getFavoriteHotels();

  Future<Hotel> favoriteHotel(
    Hotel hotel, {
    required bool isFavorite,
  });

  Future<List<Hotel>> fetchFullEntities(
    List<String> ids, {
    bool allProps = false,
  });
}
