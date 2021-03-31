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

  static DateTime _getDateForMonthAndDay(month, day) => DateTime(0, month, day);

  static List<Hotel> _generateEntities({required int multiplier}) =>
      List.generate(
              multiplier,
              (index) => [..._hotelsDB]
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

  static final _description = '''
  is on a 9.7 km stretch of private beach on Saadiyat Island. This 5-star hotel offers air-conditioned rooms with a balcony. It has a health club with an outdoor pool.

A spacious sitting area with a 42-inch flat-screen TV and an iPod docking station are in Hyatt Abu Dhabi’s modern rooms. Each has floor-to-ceiling windows and is decorated in soft colors. An open-plan bathroom with an oversize bathtub and a separate rain-shower is included.
''';

  static final _features = [
    ' 2 swimming pools',
    'Free WiFi',
    'Beachfront',
    'Free parking',
    'Family rooms',
    'Bar'
  ];
  static final _hotelsDB = [
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
      subTitle: 'Subtitle',
      dist: 123,
      imagePath: 'assets/hotel_1.png',
      perNight: 100,
      rating: 4.3,
      reviews: 34,
      isFavorite: false,
      description: _description,
      features: _features,
      roomCapacity: 1,
      personCapacity: 2,
      startWorkDate: _getDateForMonthAndDay(2, 1),
      endWorkDate: _getDateForMonthAndDay(3, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 1,
      personCapacity: 1,
      startWorkDate: _getDateForMonthAndDay(3, 1),
      endWorkDate: _getDateForMonthAndDay(4, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 2,
      personCapacity: 4,
      startWorkDate: _getDateForMonthAndDay(4, 1),
      endWorkDate: _getDateForMonthAndDay(6, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 3,
      personCapacity: 5,
      startWorkDate: _getDateForMonthAndDay(5, 1),
      endWorkDate: _getDateForMonthAndDay(6, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 3,
      personCapacity: 6,
      startWorkDate: _getDateForMonthAndDay(6, 1),
      endWorkDate: _getDateForMonthAndDay(7, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 1,
      personCapacity: 1,
      startWorkDate: _getDateForMonthAndDay(7, 1),
      endWorkDate: _getDateForMonthAndDay(8, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 3,
      personCapacity: 3,
      startWorkDate: _getDateForMonthAndDay(8, 1),
      endWorkDate: _getDateForMonthAndDay(9, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 2,
      personCapacity: 3,
      startWorkDate: _getDateForMonthAndDay(9, 1),
      endWorkDate: _getDateForMonthAndDay(10, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 4,
      personCapacity: 4,
      startWorkDate: _getDateForMonthAndDay(10, 1),
      endWorkDate: _getDateForMonthAndDay(11, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 4,
      personCapacity: 8,
      startWorkDate: _getDateForMonthAndDay(11, 1),
      endWorkDate: _getDateForMonthAndDay(12, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 4,
      personCapacity: 6,
      startWorkDate: _getDateForMonthAndDay(12, 1),
      endWorkDate: _getDateForMonthAndDay(1, 1),
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
      description: _description,
      features: _features,
      roomCapacity: 4,
      personCapacity: 7,
      startWorkDate: _getDateForMonthAndDay(1, 10),
      endWorkDate: _getDateForMonthAndDay(3, 25),
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
      description: _description,
      features: _features,
      roomCapacity: 2,
      personCapacity: 4,
      startWorkDate: _getDateForMonthAndDay(3, 26),
      endWorkDate: _getDateForMonthAndDay(5, 30),
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
      description: _description,
      features: _features,
      roomCapacity: 1,
      personCapacity: 2,
      startWorkDate: _getDateForMonthAndDay(5, 31),
      endWorkDate: _getDateForMonthAndDay(7, 10),
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
      description: _description,
      features: _features,
      roomCapacity: 2,
      personCapacity: 3,
      startWorkDate: _getDateForMonthAndDay(7, 11),
      endWorkDate: _getDateForMonthAndDay(9, 6),
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
      description: _description,
      features: _features,
      roomCapacity: 3,
      personCapacity: 5,
      startWorkDate: _getDateForMonthAndDay(9, 7),
      endWorkDate: _getDateForMonthAndDay(11, 15),
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
      description: _description,
      features: _features,
      roomCapacity: 3,
      personCapacity: 3,
      startWorkDate: _getDateForMonthAndDay(11, 16),
      endWorkDate: _getDateForMonthAndDay(1, 9),
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
      description: _description,
      features: _features,
      roomCapacity: 4,
      personCapacity: 4,
      startWorkDate: _getDateForMonthAndDay(1, 1),
      endWorkDate: _getDateForMonthAndDay(6, 30),
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
      description: _description,
      features: _features,
      roomCapacity: 1,
      personCapacity: 1,
      startWorkDate: _getDateForMonthAndDay(7, 1),
      endWorkDate: _getDateForMonthAndDay(12, 31),
    ),
  ];
}
