import 'package:rx_bloc/rx_bloc.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../../stubs.dart';
import '../factory/hotel_favorites_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      widget: hotelFavoritesFactory(
        favoriteHotels: Result.success(Stub.paginatedListEmpty),
      ), //example: Stubs.emptyList
      scenario: Scenario(name: 'hotel_favorites_empty'),
    ),
    generateDeviceBuilder(
      widget: hotelFavoritesFactory(
        favoriteHotels: Result.success(Stub.paginatedListHotelThreeAndOne),
      ), //example:  Stubs.success
      scenario: Scenario(name: 'hotel_favorites_success'),
    ),
    generateDeviceBuilder(
      widget: hotelFavoritesFactory(
        favoriteHotels: Result.loading(),
      ), //loading
      scenario: Scenario(name: 'hotel_favorites_loading'),
    ),
    generateDeviceBuilder(
      widget: hotelFavoritesFactory(
        favoriteHotels: Result.error(Stub.paginatedListError.error!),
      ),
      scenario: Scenario(name: 'hotel_favorites_error'),
    )
  ]);
}
