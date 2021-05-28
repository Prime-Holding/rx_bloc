// import 'package:favorites_advanced_base/core.dart';
// import 'package:favorites_advanced_base/src/common_data_sources/hotels_data_source.dart';
// import 'package:favorites_advanced_base/src/models/hotel_extra_details.dart';
// import 'package:favorites_advanced_base/src/models/hotel_full_extra_details.dart';
// import 'package:favorites_advanced_base/src/models/hotel_search_filters.dart';
// import 'package:flutter/material.dart';
//
// import '../models/hotel.dart';
//
// class HotelsLocalDataSource {
//   HotelsLocalDataSource({
//     required ConnectivityRepository connectivityRepository,
//     int multiplier = 500,
//   });
//
//   final _noInternetConnectionErrorString =
//       'No internet connection. Please check your settings.';
//
//   final ConnectivityRepository _connectivityRepository;
//
//   /// Simulate delays of the API http requests
//   final _artificialDelay = Duration(milliseconds: 300);
//
//   Future<List<Hotel>> getHotels({HotelSearchFilters? filters}) async {
//     await Future.delayed(_artificialDelay + Duration(milliseconds: 100));
//
//     if (!(await _connectivityRepository.isConnected())) {
//       throw Exception(_noInternetConnectionErrorString);
//     }
//
//     final query = filters?.query ?? '';
//     var copiedHotels = [..._hotels];
//
//     // If there are any other filters, apply them
//     if (filters?.advancedFiltersOn ?? false) {
//       copiedHotels = copiedHotels
//           .where((hotel) => hotel.filtersApply(
//                 range: filters!.dateRange,
//                 rooms: filters.roomCapacity,
//                 persons: filters.personCapacity,
//               ))
//           .toList();
//     }
//
//     // Sort items before returning
//     copiedHotels = _sortHotels(copiedHotels, filters?.sortBy ?? SortBy.none);
//
//     if (query == '') {
//       return copiedHotels;
//     }
//
//     return copiedHotels
//         .where(
//             (hotel) => hotel.title.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
//
//   Future<List<Hotel>> getFavoriteHotels() async {
//     await Future.delayed(_artificialDelay);
//
//     if (!(await _connectivityRepository.isConnected())) {
//       throw Exception(_noInternetConnectionErrorString);
//     }
//
//     return _hotels.where((hotel) => hotel.isFavorite).toList();
//   }
//
//   Future<Hotel> favoriteHotel(
//     Hotel hotel, {
//     required bool isFavorite,
//   }) async {
//     await Future.delayed(_artificialDelay);
//
//     if (!(await _connectivityRepository.isConnected())) {
//       throw Exception(_noInternetConnectionErrorString);
//     }
//
//     final foundHotel = _hotels.firstWhere(
//       (item) => item.id == hotel.id,
//     );
//
//     foundHotel.isFavorite = isFavorite;
//
//     return foundHotel;
//   }
//
//   Future<List<Hotel>> fetchFullEntities(
//     List<String> ids, {
//     bool allProps = false,
//   }) async {
//     await Future.delayed(_artificialDelay);
//
//     if (!(await _connectivityRepository.isConnected())) {
//       throw Exception(_noInternetConnectionErrorString);
//     }
//
//     final hotelsWithExtraData = _hotels
//         .where((element) => ids.contains(element.id))
//         .map((hotel) => hotel.copyWith(
//               displayRating: hotel.rating,
//               displaySubtitle: hotel.subTitle,
//               displayReviews: hotel.reviews,
//               displayDist: hotel.dist,
//             ))
//         .map((hotel) => allProps
//             ? hotel.copyWith(
//                 displayDescription: hotel.description,
//                 displayFeatures: hotel.features,
//               )
//             : hotel)
//         .toList();
//
//     return hotelsWithExtraData;
//   }
// }
