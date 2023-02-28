import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc_list/models.dart';

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

  Future<PaginatedList<Hotel>> getHotelsPaginated({
    required HotelSearchFilters filters,
    required int pageSize,
    required int page,
  }) async {
    final hotels = await getHotels(filters: filters);

    return PaginatedList(
      list: hotels.getPage(
        pageSize: pageSize,
        page: page,
      ),
      pageSize: pageSize,
      totalCount: hotels.length,
    );
  }

  @override
  Future<List<Hotel>> getFavoriteHotels() => _repository.getFavoriteHotels();

  @override
  Future<List<Hotel>> getHotels({HotelSearchFilters? filters}) =>
      _repository.getHotels(filters: filters);

  @override
  Future<Hotel> favoriteHotel(Hotel hotel, {required bool isFavorite}) =>
      _repository.favoriteHotel(hotel, isFavorite: isFavorite);

  @override
  Future<List<Hotel>> fetchFullEntities(
    List<String> ids, {
    bool allProps = false,
  }) =>
      _repository.fetchFullEntities(
        ids,
        allProps: allProps,
      );

  @override
  Future<Hotel> hotelById(String hotelId) => _repository.hotelById(hotelId);
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
