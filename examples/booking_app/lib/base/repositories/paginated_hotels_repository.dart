import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc_list/models.dart';

class PaginatedHotelsRepository implements HotelsRepository {
  PaginatedHotelsRepository(HotelsRepository repository)
      : _repository = repository;

  final HotelsRepository _repository;

  Future<PaginatedList<Hotel>> getFavoriteHotelsPaginated({
    required int pageSize,
    required int page,
  }) async =>
      PaginatedList(
        list: (await getFavoriteHotels()).getPage(
          pageSize: pageSize,
          page: page,
        ),
        pageSize: pageSize,
      );

  Future<PaginatedList<Hotel>> getHotelsPaginated({
    required String query,
    required int pageSize,
    required int page,
  }) async =>
      PaginatedList(
        list: (await getHotels(query: query)).getPage(
          pageSize: pageSize,
          page: page,
        ),
        pageSize: pageSize,
      );

  @override
  Future<List<Hotel>> getFavoriteHotels() => _repository.getFavoriteHotels();

  @override
  Future<List<Hotel>> getHotels({String query = ''}) =>
      _repository.getHotels(query: query);

  @override
  Future<Hotel> favoriteHotel(Hotel hotel, {required bool isFavorite}) =>
      _repository.favoriteHotel(hotel, isFavorite: isFavorite);

  @override
  Future<List<Hotel>> fetchFullEntities(List<String> ids) =>
      _repository.fetchFullEntities(ids);
}

extension _HotelList on List<Hotel> {
  List<Hotel> getPage({
    required int pageSize,
    required int page,
  }) {
    final startRange = (page - 1) * pageSize;
    final endRange = startRange + pageSize;
    return getRange(startRange, endRange > length ? length : endRange).toList();
  }
}
