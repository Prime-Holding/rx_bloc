import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/src/models/hotel_search_filters.dart';
import 'package:flutter/material.dart';

import '../models/hotel.dart';
import 'connectivity_repository.dart';

class HotelsRepository {
  HotelsRepository(
    ConnectivityRepository connectivityRepository, {
    int multiplier = 500,
  })  : _connectivityRepository = connectivityRepository,
        _hotels = _generateEntities(
          multiplier: multiplier,
        );

  final _noInternetConnectionErrorString =
      'No internet connection. Please check your settings.';

  /// Simulate delays of the API http requests
  final _artificialDelay = Duration(milliseconds: 300);

  final ConnectivityRepository _connectivityRepository;

  Future<List<Hotel>> getHotels({HotelSearchFilters? filters}) async {


    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    await Future.delayed(_artificialDelay + Duration(milliseconds: 2000));

    final query = filters?.query ?? '';
    var copiedHotels = [..._hotels];

    // If there are any other filters, apply them
    if (filters?.advancedFiltersOn ?? false) {
      copiedHotels = copiedHotels
          .where((hotel) => hotel.filtersApply(
                range: filters!.dateRange,
                rooms: filters.roomCapacity,
                persons: filters.personCapacity,
              ))
          .toList();
    }

    // Sort items before returning
    copiedHotels = _sortHotels(copiedHotels, filters?.sortBy ?? SortBy.none);

    if (query == '') {
      return copiedHotels;
    }

    return copiedHotels
        .where(
            (hotel) => hotel.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Hotel>> getFavoriteHotels() async {
    await Future.delayed(_artificialDelay);

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    return _hotels.where((hotel) => hotel.isFavorite).toList();
  }

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
    );

    foundHotel.isFavorite = isFavorite;

    return foundHotel;
  }

  Future<List<Hotel>> fetchFullEntities(
    List<String> ids, {
    bool allProps = false,
  }) async {
    await Future.delayed(_artificialDelay);

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    final hotelsWithExtraData = _hotels
        .where((element) => ids.contains(element.id))
        .map((hotel) => hotel.copyWith(
              displayRating: hotel.rating,
              displaySubtitle: hotel.subTitle,
              displayReviews: hotel.reviews,
              displayDist: hotel.dist,
            ))
        .map((hotel) => allProps
            ? hotel.copyWith(
                displayDescription: hotel.description,
                displayFeatures: hotel.features,
              )
            : hotel)
        .toList();

    return hotelsWithExtraData;
  }

  List<Hotel> _hotels;

  static DateTime _getDateForMonthAndDay(int month, int day,
          [bool isNextYear = false]) =>
      DateTime(DateTime.now().year + (isNextYear ? 1 : 0), month, day);

  static List<Hotel> _sortHotels(List<Hotel> hotels, SortBy sortType) {
    // Sort by price
    if (sortType == SortBy.priceAsc || sortType == SortBy.priceDesc) {
      final desc = sortType == SortBy.priceDesc;
      hotels.sort(
        (h1, h2) => desc
            ? h2.perNight.compareTo(h1.perNight)
            : h1.perNight.compareTo(h2.perNight),
      );
    }

    // Sort by distance
    if (sortType == SortBy.distanceAsc || sortType == SortBy.distanceDesc) {
      final desc = sortType == SortBy.distanceDesc;
      hotels.sort(
        (h1, h2) =>
            desc ? h1.dist.compareTo(h2.dist) : h2.dist.compareTo(h1.dist),
      );
    }

    return hotels;
  }

  static List<Hotel> _generateEntities({required int multiplier}) =>
      List.generate(
              multiplier,
              (index) => [...hotelsDB]
                  .map(
                    (hotel) => hotel.copyWith(
                      id: "$index-${hotel.id}",
                      isFavorite: false,
                    ),
                  )
                  .toList())
          .expand((element) => element)
          .toList()
          .asMap()
          .entries
          .map(
            (entry) => entry.value
                .copyWith(title: "${entry.key} - ${entry.value.title}"),
          )
          .toList();

  static final _description = '''
 is situated on a 9 km stretch of private beach on Saadiyat Island. This hotel offers air-conditioned rooms with a balcony. It has a health club with an outdoor pool.

A spacious seating area with a 42-inch flat-screen TV and an iPod docking station are in Hyatt Abu Dhabi’s modern rooms. Each has floor-to-ceiling windows and is decorated in soft colours. An open-plan bathroom with an oversized bathtub and a separate rain-shower is included.

Relaxing massages and various beauty treatments are available at Atarmia Spa. It includes a gym and private treatment rooms for men and women.

Park Hyatt Abu Dhabi Hotel and Villas has 3 in-house restaurants.
Each offers a wide selection of international cuisine. The Beach House Restaurant features panoramic views of Saadiyat Beach and the landscaped hotel gardens.

Abu Dhabi International Airport is 35 minutes’ drive away. Park Hyatt Abu Dhabi provides free parking on site.

Couples particularly like the location — they rated it 9.3 for a two-person trip.

We speak your language!
''';

  static final _features = [
    'Free WiFi',
    'Beachfront',
    'Free parking',
    'Family rooms',
    'Bar',
  ];
  static final hotelsDB = [
    Hotel(
      id: '1',
      title: 'Premier Inn Dubai International Airport',
      subTitle: '4 Stars',
      dist: 120,
      imagePath: 'assets/hotel_0.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: _description,
      features: _features,
      roomCapacity: 2,
      personCapacity: 4,
      startWorkDate: _getDateForMonthAndDay(1, 1),
      endWorkDate: _getDateForMonthAndDay(2, 1),
    ),
    Hotel(
      id: '2',
      title: 'Avani Deira Dubai Hotel',
      subTitle: '5 Stars',
      dist: 62,
      imagePath: 'assets/hotel_1.png',
      perNight: 170,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Avani Deira Dubai Hotel $_description',
      features: _features,
      roomCapacity: 1,
      personCapacity: 2,
      startWorkDate: _getDateForMonthAndDay(2, 1),
      endWorkDate: _getDateForMonthAndDay(3, 1),
    ),
    Hotel(
      id: '3',
      title: 'Swissotel Al Ghurair',
      subTitle: '3 Stars',
      dist: 320,
      imagePath: 'assets/hotel_2.png',
      perNight: 135,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Swissotel Al Ghurair $_description',
      features: _features,
      roomCapacity: 1,
      personCapacity: 1,
      startWorkDate: _getDateForMonthAndDay(3, 1),
      endWorkDate: _getDateForMonthAndDay(4, 1),
    ),
    Hotel(
      id: '4',
      title: 'Hyatt Place Dubai Jumeirah Residences',
      subTitle: '6 Stars',
      dist: 280,
      imagePath: 'assets/hotel_3.png',
      perNight: 200,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Hyatt Place Dubai Jumeirah Residences $_description',
      features: _features,
      roomCapacity: 2,
      personCapacity: 4,
      startWorkDate: _getDateForMonthAndDay(4, 1),
      endWorkDate: _getDateForMonthAndDay(6, 1),
    ),
    Hotel(
      id: '5',
      title: 'Ramee Rose Hotel',
      subTitle: '5 Stars',
      dist: 125,
      imagePath: 'assets/hotel_4.png',
      perNight: 150,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Ramee Rose Hotel $_description',
      features: _features,
      roomCapacity: 3,
      personCapacity: 5,
      startWorkDate: _getDateForMonthAndDay(5, 1),
      endWorkDate: _getDateForMonthAndDay(6, 1),
    ),
    Hotel(
      id: '6',
      title: 'Atana Hotel',
      subTitle: '5 Stars',
      dist: 172,
      imagePath: 'assets/hotel_5.png',
      perNight: 220,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Atana Hotel $_description',
      features: _features,
      roomCapacity: 3,
      personCapacity: 6,
      startWorkDate: _getDateForMonthAndDay(6, 1),
      endWorkDate: _getDateForMonthAndDay(7, 1),
    ),
    Hotel(
      id: '7',
      title: 'Rove Healthcare City',
      subTitle: '6 Stars',
      dist: 88,
      imagePath: 'assets/hotel_6.png',
      perNight: 140,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Rove Healthcare City $_description',
      features: _features,
      roomCapacity: 1,
      personCapacity: 1,
      startWorkDate: _getDateForMonthAndDay(7, 1),
      endWorkDate: _getDateForMonthAndDay(8, 1),
    ),
    Hotel(
      id: '8',
      title: 'Rove Healthcare',
      subTitle: '5 Stars',
      dist: 165,
      imagePath: 'assets/hotel_7.png',
      perNight: 85,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Rove Healthcare $_description',
      features: _features,
      roomCapacity: 3,
      personCapacity: 3,
      startWorkDate: _getDateForMonthAndDay(8, 1),
      endWorkDate: _getDateForMonthAndDay(9, 1),
    ),
    Hotel(
      id: '9',
      title: 'Millennium Airport Hotel Dubai',
      subTitle: '4 Stars',
      dist: 150,
      imagePath: 'assets/hotel_8.png',
      perNight: 65,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Millennium Airport Hotel Dubai $_description',
      features: _features,
      roomCapacity: 2,
      personCapacity: 3,
      startWorkDate: _getDateForMonthAndDay(9, 1),
      endWorkDate: _getDateForMonthAndDay(10, 1),
    ),
    Hotel(
      id: '10',
      title: 'Millennium Airport',
      subTitle: '6 Stars',
      dist: 98,
      imagePath: 'assets/hotel_9.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Millennium Airport $_description',
      features: _features,
      roomCapacity: 4,
      personCapacity: 4,
      startWorkDate: _getDateForMonthAndDay(10, 1),
      endWorkDate: _getDateForMonthAndDay(11, 1),
    ),
    Hotel(
      id: '11',
      title: 'Millennium Airport Hotel Dubai',
      subTitle: '5 Stars',
      dist: 83,
      imagePath: 'assets/hotel_10.png',
      perNight: 120,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Millennium Airport Hotel Dubai $_description',
      features: _features,
      roomCapacity: 4,
      personCapacity: 8,
      startWorkDate: _getDateForMonthAndDay(11, 1),
      endWorkDate: _getDateForMonthAndDay(12, 1),
    ),
    Hotel(
      id: '12',
      title: 'Millennium Airport Hotel Dubai',
      subTitle: '5 Stars',
      dist: 137,
      imagePath: 'assets/hotel_11.png',
      perNight: 70,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Millennium Airport Hotel Dubai $_description',
      features: _features,
      roomCapacity: 4,
      personCapacity: 6,
      startWorkDate: _getDateForMonthAndDay(12, 1),
      endWorkDate: _getDateForMonthAndDay(1, 1, true),
    ),
    Hotel(
      id: '13',
      title: 'Millennium Airport Hotel Dubai',
      subTitle: '5 Stars',
      dist: 178,
      imagePath: 'assets/hotel_12.png',
      perNight: 220,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Millennium Airport Hotel Dubai $_description',
      features: _features,
      roomCapacity: 4,
      personCapacity: 7,
      startWorkDate: _getDateForMonthAndDay(1, 10),
      endWorkDate: _getDateForMonthAndDay(3, 25),
    ),
    Hotel(
      id: '14',
      title: 'Taj Dubai',
      subTitle: '6 Stars',
      dist: 283,
      imagePath: 'assets/hotel_13.png',
      perNight: 80,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Taj Dubai $_description',
      features: _features,
      roomCapacity: 2,
      personCapacity: 4,
      startWorkDate: _getDateForMonthAndDay(3, 26),
      endWorkDate: _getDateForMonthAndDay(5, 30),
    ),
    Hotel(
      id: '15',
      title: 'Rove Downtown Dubai',
      subTitle: '5 Stars',
      dist: 313,
      imagePath: 'assets/hotel_14.png',
      perNight: 110,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Rove Downtown Dubai $_description',
      features: _features,
      roomCapacity: 1,
      personCapacity: 2,
      startWorkDate: _getDateForMonthAndDay(5, 31),
      endWorkDate: _getDateForMonthAndDay(7, 10),
    ),
    Hotel(
      id: '16',
      title: 'Premier Inn Dubai Al Jaddaf',
      subTitle: '5 Stars',
      dist: 295,
      imagePath: 'assets/hotel_15.png',
      perNight: 99,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Premier Inn Dubai Al Jaddaf $_description',
      features: _features,
      roomCapacity: 2,
      personCapacity: 3,
      startWorkDate: _getDateForMonthAndDay(7, 11),
      endWorkDate: _getDateForMonthAndDay(9, 6),
    ),
    Hotel(
      id: '17',
      title: 'Hyatt Place Dubai Al Rigga Residences',
      subTitle: '5 Stars',
      dist: 104,
      imagePath: 'assets/hotel_16.png',
      perNight: 120,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Hyatt Place Dubai Al Rigga Residences $_description',
      features: _features,
      roomCapacity: 3,
      personCapacity: 5,
      startWorkDate: _getDateForMonthAndDay(9, 7),
      endWorkDate: _getDateForMonthAndDay(11, 15),
    ),
    Hotel(
      id: 'Hyatt Place Dubai Al Rigga Residences',
      title: '5 Stars',
      subTitle: 'Subtitle',
      dist: 192,
      imagePath: 'assets/hotel_17.png',
      perNight: 150,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Hyatt Place Dubai Al Rigga Residences $_description',
      features: _features,
      roomCapacity: 3,
      personCapacity: 3,
      startWorkDate: _getDateForMonthAndDay(11, 16),
      endWorkDate: _getDateForMonthAndDay(1, 9, true),
    ),
    Hotel(
      id: '19',
      title: 'Hyatt Place Dubai Al Rigga Residences',
      subTitle: '5 Stars',
      dist: 380,
      imagePath: 'assets/hotel_18.png',
      perNight: 79,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Hyatt Place Dubai Al Rigga Residences $_description',
      features: _features,
      roomCapacity: 4,
      personCapacity: 4,
      startWorkDate: _getDateForMonthAndDay(1, 1),
      endWorkDate: _getDateForMonthAndDay(6, 30),
    ),
    Hotel(
      id: '20',
      title: 'Regal Plaza Hotel',
      subTitle: '6 Stars',
      dist: 123,
      imagePath: 'assets/hotel_19.png',
      perNight: 200,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: 'Regal Plaza Hotel $_description',
      features: _features,
      roomCapacity: 1,
      personCapacity: 1,
      startWorkDate: _getDateForMonthAndDay(7, 1),
      endWorkDate: _getDateForMonthAndDay(12, 31),
    ),
  ];
}

extension _HotelExtensions on Hotel {
  /// Performs a check whether the provided filters apply for the current hotel.
  bool filtersApply(
          {required DateTimeRange? range,
          required int rooms,
          required int persons}) =>
      _withinWorkRange(range) &&
      _hasEnoughRooms(rooms) &&
      _hasPlaceForPeople(persons);

  /// Does the current hotel work within the current date range?
  bool _withinWorkRange(DateTimeRange? range) => range != null
      ? (startWorkDate.isBefore(range.start) && endWorkDate.isAfter(range.end))
      : true;

  /// Has the current hotel enough rooms?
  bool _hasEnoughRooms(int rooms) => rooms > 0 ? roomCapacity > rooms : true;

  /// Can the hotel accommodate a select number of persons?
  bool _hasPlaceForPeople(int persons) =>
      persons > 0 ? personCapacity > persons : true;
}
