import 'dart:io';

import 'connectivity_repository.dart';

import '../models/hotel.dart';

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

  Future<List<Hotel>> getHotels({String query = ''}) async {
    await Future.delayed(_artificialDelay + Duration(milliseconds: 100));

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    if (query == '') {
      return _hotels;
    }

    final copiedHotels = [..._hotels];

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

    return _hotels.where((puppy) => puppy.isFavorite).toList();
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

  Future<List<Hotel>> fetchFullEntities(List<String> ids) async {
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
        .toList();

    return hotelsWithExtraData;
  }

  List<Hotel> _hotels;

  static List<Hotel> _generateEntities({required int multiplier}) =>
      List.generate(
              multiplier,
              (index) => [..._puppiesDB]
                  .map(
                    (puppy) => puppy.copyWith(
                      id: "$index-${puppy.id}",
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
                .copyWith(title: "${entry.value.title} ${entry.key}"),
          )
          .toList();

  static final _puppiesDB = [
    Hotel(
      id: '1',
      title: 'Premier Inn Dubai International Airport',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_0.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '2',
      title: 'Avani Deira Dubai Hotel',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_1.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '3',
      title: 'Swissotel Al Ghurair',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_2.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '4',
      title: 'Hyatt Place Dubai Jumeirah Residences',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_3.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '5',
      title: 'Ramee Rose Hotel',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_4.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '6',
      title: 'Atana Hotel',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_5.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '7',
      title: 'Rove Healthcare City',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_6.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '8',
      title: 'Rove Healthcare',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_7.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '9',
      title: 'Millennium Airport Hotel Dubai',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_8.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '10',
      title: 'Hotel',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_9.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '11',
      title: 'Millennium Airport Hotel Dubai',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_10.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '12',
      title: 'Millennium Airport Hotel Dubai',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_11.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '13',
      title: 'Millennium Airport Hotel Dubai',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_12.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '14',
      title: 'Taj Dubai',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_13.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '15',
      title: 'Rove Downtown Dubai',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_14.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '16',
      title: 'Premier Inn Dubai Al Jaddaf',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_15.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '17',
      title: 'Hyatt Place Dubai Al Rigga Residences',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_16.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: 'Hyatt Place Dubai Al Rigga Residences',
      title: 'Hotel',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_17.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '19',
      title: 'Hyatt Place Dubai Al Rigga Residences',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_18.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
    Hotel(
      id: '20',
      title: 'Regal Plaza Hotel',
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_19.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
    ),
  ];
}
