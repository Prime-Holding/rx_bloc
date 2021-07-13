import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rx_bloc_list/models.dart';

import '../remote_data_sources/hotels_data_source.dart';

class HotelsLocalDataSource implements HotelsDataSource {
  HotelsLocalDataSource({
    required ConnectivityRepository connectivityRepository,
    int multiplier = 500,
  }) {
    _connectivityRepository = connectivityRepository;
    _hotels = HotelsService.generateEntities(multiplier: multiplier);
    _hotelsExtraDetails = HotelsService.generateExtraEntries(
      hotels: _hotels,
      multiplier: multiplier,
    );
    _hotelsExtraFullDetails = HotelsService.generateFullExtraEntries(
      hotels: _hotels,
      multiplier: multiplier,
    );
  }

  final _noInternetConnectionErrorString =
      'No internet connection. Please check your settings.';

  late final ConnectivityRepository _connectivityRepository;

  /// Simulate delays of the API http requests
  final _artificialDelay = const Duration(milliseconds: 300);

  late List<Hotel> _hotels;
  late List<HotelExtraDetails> _hotelsExtraDetails;
  late List<HotelFullExtraDetails> _hotelsExtraFullDetails;

  @override
  Future<PaginatedList<Hotel>> getHotels({
    required int page,
    required int pageSize,
    HotelSearchFilters? filters,
  }) async {
    await Future.delayed(_artificialDelay + const Duration(milliseconds: 100));

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    final copiedHotels = [..._hotels];
    final hotelsFiltered = HotelsService.applyLocalFilters(
      copiedHotels,
      filters,
    );

    return PaginatedList(
      list: hotelsFiltered,
      pageSize: pageSize,
      totalCount: hotelsFiltered.length,
    );
  }

  @override
  Future<List<Hotel>> getFavoriteHotels() async {
    await Future.delayed(_artificialDelay);

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    return _hotels.where((hotel) => hotel.isFavorite).toList();
  }

  @override
  Future<Hotel> favoriteHotel(
    Hotel hotel, {
    required bool isFavorite,
  }) async {
    await Future.delayed(_artificialDelay);

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    final foundHotel = _hotels.firstWhere(
      (item) => item.id == hotel.id,
    )..isFavorite = isFavorite;

    return foundHotel;
  }

  @override
  Future<List<HotelExtraDetails>> fetchExtraDetails(List<String> ids) async {
    await Future.delayed(_artificialDelay);

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    final hotelsWithExtraData = _hotelsExtraDetails
        .where((element) => ids.contains(element.hotelId))
        .toList();

    return hotelsWithExtraData;
  }

  @override
  Future<HotelFullExtraDetails> fetchFullExtraDetails(String hotelId) async {
    await Future.delayed(_artificialDelay);

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    final hotelWithFullExtraData = _hotelsExtraFullDetails
        .firstWhere((element) => hotelId == element.hotelId);

    return hotelWithFullExtraData;
  }

  @override
  Future<void> seed() {
    // TODO: implement seed
    throw UnimplementedError();
  }
}
