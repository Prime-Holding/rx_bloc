import 'package:booking_app/base/remote_data_sources/hotels_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/src/models/hotel_search_filters.dart';

class HotelsRepository {
  HotelsRepository({
    required HotelsDataSource hotelsDataSource,
  }) : _hotelsDataSource = hotelsDataSource;

  final HotelsDataSource _hotelsDataSource;

  Future<List<QueryDocumentSnapshot>> getHotels(
          {HotelSearchFilters? filters, QueryDocumentSnapshot? lastFetched}) =>
      _hotelsDataSource.getHotels(filters: filters, lastFetched: lastFetched);

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

  Future<String> fetchFeaturedImage(Hotel hotel) =>
      _hotelsDataSource.fetchFeaturedImage(hotel);
}
