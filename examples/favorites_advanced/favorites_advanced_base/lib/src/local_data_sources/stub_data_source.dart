import 'package:favorites_advanced_base/core.dart';

class StubDataSource {
  static const _description = '''
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
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_0.png?alt=media',
      perNight: 100,
      isFavorite: false,
      roomCapacity: 2,
      personCapacity: 4,
      workingDate: _getDateForMonthAndDay(1, 1),
      dist: 120.00,
    ),
    Hotel(
      id: '2',
      title: 'Avani Deira Dubai Hotel',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_1.png?alt=media',
      perNight: 170,
      isFavorite: false,
      roomCapacity: 1,
      personCapacity: 2,
      workingDate: _getDateForMonthAndDay(2, 1),
      dist: 62.00,
    ),
    Hotel(
      id: '3',
      title: 'Swissotel Al Ghurair',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_2.png?alt=media',
      perNight: 135,
      isFavorite: false,
      roomCapacity: 1,
      personCapacity: 1,
      workingDate: _getDateForMonthAndDay(3, 1),
      dist: 320.00,
    ),
    Hotel(
      id: '4',
      title: 'Hyatt Place Dubai Jumeirah Residences',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_3.png?alt=media',
      perNight: 200,
      isFavorite: false,
      roomCapacity: 2,
      personCapacity: 4,
      workingDate: _getDateForMonthAndDay(4, 1),
      dist: 55.00,
    ),
    Hotel(
      id: '5',
      title: 'Ramee Rose Hotel',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_4.png?alt=media',
      perNight: 150,
      isFavorite: false,
      roomCapacity: 3,
      personCapacity: 5,
      workingDate: _getDateForMonthAndDay(5, 1),
      dist: 550.00,
    ),
    Hotel(
      id: '6',
      title: 'Atana Hotel',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_5.png?alt=media',
      perNight: 220,
      isFavorite: false,
      roomCapacity: 3,
      personCapacity: 6,
      workingDate: _getDateForMonthAndDay(6, 1),
      dist: 190.00,
    ),
    Hotel(
      id: '7',
      title: 'Rove Healthcare City',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_6.png?alt=media',
      perNight: 140,
      isFavorite: false,
      roomCapacity: 1,
      personCapacity: 1,
      workingDate: _getDateForMonthAndDay(7, 1),
      dist: 221.00,
    ),
    Hotel(
      id: '8',
      title: 'Rove Healthcare',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_7.png?alt=media',
      perNight: 85,
      isFavorite: false,
      roomCapacity: 3,
      personCapacity: 3,
      workingDate: _getDateForMonthAndDay(8, 1),
      dist: 321.00,
    ),
    Hotel(
      id: '9',
      title: 'Millennium Airport Hotel Dubai',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_8.png?alt=media',
      perNight: 65,
      isFavorite: false,
      roomCapacity: 2,
      personCapacity: 3,
      workingDate: _getDateForMonthAndDay(9, 1),
      dist: 96.00,
    ),
    Hotel(
      id: '10',
      title: 'Millennium Airport',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_9.png?alt=media',
      perNight: 100,
      isFavorite: false,
      roomCapacity: 4,
      personCapacity: 4,
      workingDate: _getDateForMonthAndDay(10, 1),
      dist: 57.00,
    ),
    Hotel(
      id: '11',
      title: 'Millennium Airport Hotel Dubai',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_10.png?alt=media',
      perNight: 120,
      isFavorite: false,
      roomCapacity: 4,
      personCapacity: 8,
      workingDate: _getDateForMonthAndDay(11, 1),
      dist: 1200.00,
    ),
    Hotel(
      id: '12',
      title: 'Millennium Airport Hotel Dubai',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_11.png?alt=media',
      perNight: 70,
      isFavorite: false,
      roomCapacity: 4,
      personCapacity: 6,
      workingDate: _getDateForMonthAndDay(12, 1),
      dist: 1321.00,
    ),
    Hotel(
      id: '13',
      title: 'Millennium Airport Hotel Dubai',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_12.png?alt=media',
      perNight: 220,
      isFavorite: false,
      roomCapacity: 4,
      personCapacity: 7,
      workingDate: _getDateForMonthAndDay(1, 10, true),
      dist: 3221.00,
    ),
    Hotel(
      id: '14',
      title: 'Taj Dubai',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_13.png?alt=media',
      perNight: 80,
      isFavorite: false,
      roomCapacity: 2,
      personCapacity: 4,
      workingDate: _getDateForMonthAndDay(3, 26),
      dist: 111.00,
    ),
    Hotel(
      id: '15',
      title: 'Rove Downtown Dubai',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_14.png?alt=media',
      perNight: 110,
      isFavorite: false,
      roomCapacity: 1,
      personCapacity: 2,
      workingDate: _getDateForMonthAndDay(5, 31, true),
      dist: 666.00,
    ),
    Hotel(
      id: '16',
      title: 'Premier Inn Dubai Al Jaddaf',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_15.png?alt=media',
      perNight: 99,
      isFavorite: false,
      roomCapacity: 2,
      personCapacity: 3,
      workingDate: _getDateForMonthAndDay(7, 11),
      dist: 777.00,
    ),
    Hotel(
      id: '17',
      title: 'Hyatt Place Dubai Al Rigga Residences',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_16.png?alt=media',
      perNight: 120,
      isFavorite: false,
      roomCapacity: 3,
      personCapacity: 5,
      workingDate: _getDateForMonthAndDay(9, 7),
      dist: 821.00,
    ),
    Hotel(
      id: '18',
      title: '5 Stars',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_17.png?alt=media',
      perNight: 150,
      isFavorite: false,
      roomCapacity: 3,
      personCapacity: 3,
      workingDate: _getDateForMonthAndDay(11, 16),
      dist: 444.00,
    ),
    Hotel(
      id: '19',
      title: 'Hyatt Place Dubai Al Rigga Residences',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_18.png?alt=media',
      perNight: 79,
      isFavorite: false,
      roomCapacity: 4,
      personCapacity: 4,
      workingDate: _getDateForMonthAndDay(1, 1),
      dist: 357.00,
    ),
    Hotel(
      id: '20',
      title: 'Regal Plaza Hotel',
      image:
          'https://firebasestorage.googleapis.com/v0/b/booking-2c3df.appspot.com/o/images%2Fhotel_19.png?alt=media',
      perNight: 200,
      isFavorite: false,
      roomCapacity: 1,
      personCapacity: 1,
      workingDate: _getDateForMonthAndDay(7, 1),
      dist: 123.00,
    ),
  ];

  static final hotelsExtraDetailsDB = [
    HotelExtraDetails(
      id: '1',
      hotelId: '1',
      subTitle: '4 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '2',
      hotelId: '2',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '3',
      hotelId: '3',
      subTitle: '3 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '4',
      hotelId: '4',
      subTitle: '6 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '5',
      hotelId: '5',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '6',
      hotelId: '6',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '7',
      hotelId: '7',
      subTitle: '6 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '8',
      hotelId: '8',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '9',
      hotelId: '9',
      subTitle: '4 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '10',
      hotelId: '10',
      subTitle: '6 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '11',
      hotelId: '11',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '12',
      hotelId: '12',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '13',
      hotelId: '13',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '14',
      hotelId: '14',
      subTitle: '6 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '15',
      hotelId: '15',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '16',
      hotelId: '16',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '17',
      hotelId: '17',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '18',
      hotelId: '18',
      subTitle: 'Subtitle',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '19',
      hotelId: '19',
      subTitle: '5 Stars',
      rating: 4.3,
      reviews: 34,
    ),
    HotelExtraDetails(
      id: '20',
      hotelId: '20',
      subTitle: '6 Stars',
      rating: 4.3,
      reviews: 34,
    ),
  ];

  static final hotelsFullExtraDetailsDB = [
    HotelFullExtraDetails(
      id: '1',
      hotelId: '1',
      description: _description,
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '2',
      hotelId: '2',
      description: 'Avani Deira Dubai Hotel $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '3',
      hotelId: '3',
      description: 'Swissotel Al Ghurair $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '4',
      hotelId: '4',
      description: 'Hyatt Place Dubai Jumeirah Residences $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '5',
      hotelId: '5',
      description: 'Ramee Rose Hotel $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '6',
      hotelId: '6',
      description: 'Atana Hotel $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '7',
      hotelId: '7',
      description: 'Rove Healthcare City $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '8',
      hotelId: '8',
      description: 'Rove Healthcare $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '9',
      hotelId: '9',
      description: 'Millennium Airport Hotel Dubai $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '10',
      hotelId: '10',
      description: 'Millennium Airport $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '11',
      hotelId: '11',
      description: 'Millennium Airport Hotel Dubai $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '12',
      hotelId: '12',
      description: 'Millennium Airport Hotel Dubai $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '13',
      hotelId: '13',
      description: 'Millennium Airport Hotel Dubai $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '14',
      hotelId: '14',
      description: 'Taj Dubai $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '15',
      hotelId: '15',
      description: 'Rove Downtown Dubai $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '16',
      hotelId: '16',
      description: 'Premier Inn Dubai Al Jaddaf $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '17',
      hotelId: '17',
      description: 'Hyatt Place Dubai Al Rigga Residences $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '18',
      hotelId: '18',
      description: 'Hyatt Place Dubai Al Rigga Residences $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '19',
      hotelId: '19',
      description: 'Hyatt Place Dubai Al Rigga Residences $_description',
      features: _features,
    ),
    HotelFullExtraDetails(
      id: '20',
      hotelId: '20',
      description: 'Regal Plaza Hotel $_description',
      features: _features,
    ),
  ];

  static DateTime _getDateForMonthAndDay(int month, int day,
          [bool isNextYear = false]) =>
      DateTime(DateTime.now().year + (isNextYear ? 1 : 0), month, day);
}
