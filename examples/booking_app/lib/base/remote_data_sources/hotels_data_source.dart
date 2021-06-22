import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorites_advanced_base/core.dart';

abstract class HotelsDataSource {
  Future<List<QueryDocumentSnapshot>> getHotels(
      {HotelSearchFilters? filters, QueryDocumentSnapshot? lastFetched});

  Future<List<Hotel>> getFavoriteHotels();

  Future<Hotel> favoriteHotel(
    Hotel hotel, {
    required bool isFavorite,
  });

  Future<List<HotelExtraDetails>> fetchExtraDetails(List<String> ids);

  Future<HotelFullExtraDetails> fetchFullExtraDetails(String hotelId);

  Future<String> fetchFeaturedImage(Hotel hotel);

  Future<void> seed();
}
