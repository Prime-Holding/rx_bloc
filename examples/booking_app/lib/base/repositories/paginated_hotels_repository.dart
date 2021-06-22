import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc_list/models.dart';

import 'hotels_repository.dart';

class PaginatedHotelsRepository implements HotelsRepository {
  PaginatedHotelsRepository(HotelsRepository repository)
      : _repository = repository;

  final HotelsRepository _repository;

  Future<PaginatedList<Hotel>> getFavoriteHotelsPaginated({
    required int pageSize,
    required int page,
  }) async {
    final hotels = await getFavoriteHotels();

    return PaginatedList(
      list: hotels.getPage(
        pageSize: pageSize,
        page: page,
      ),
      pageSize: pageSize,
      totalCount: hotels.length,
    );
  }

  Future<List<QueryDocumentSnapshot>> getHotelsPaginated({
    required HotelSearchFilters filters,
    required int pageSize,
    required int page,
    QueryDocumentSnapshot? lastFetchedDocument,
  }) async =>
      getHotels(filters: filters, lastFetched: lastFetchedDocument);

  @override
  Future<List<Hotel>> getFavoriteHotels() => _repository.getFavoriteHotels();

  @override
  Future<List<QueryDocumentSnapshot>> getHotels({
    HotelSearchFilters? filters,
    QueryDocumentSnapshot? lastFetched,
  }) =>
      _repository.getHotels(filters: filters, lastFetched: lastFetched);

  @override
  Future<Hotel> favoriteHotel(Hotel hotel, {required bool isFavorite}) =>
      _repository.favoriteHotel(hotel, isFavorite: isFavorite);

  @override
  Future<List<HotelExtraDetails>> fetchExtraDetails(List<String> ids) =>
      _repository.fetchExtraDetails(ids);

  @override
  Future<HotelFullExtraDetails> fetchFullExtraDetails(String hotelId) =>
      _repository.fetchFullExtraDetails(hotelId);

  @override
  Future<String> fetchFeaturedImage(Hotel hotel) =>
      _repository.fetchFeaturedImage(hotel);
}

extension _HotelList on List<Hotel> {
  List<Hotel> getPage({
    required int pageSize,
    required int page,
  }) {
    final startRange = (page - 1) * pageSize;
    final endRange = startRange + pageSize;
    if (startRange > length) return [];
    return getRange(startRange, endRange > length ? length : endRange).toList();
  }
}
