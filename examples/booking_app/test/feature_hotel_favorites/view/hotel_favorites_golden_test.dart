import 'package:rx_bloc/rx_bloc.dart';

import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/hotel_favorites_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      widget: hotelFavoritesFactory(
        favoriteHotelsResult: Result.success(Stub.paginatedListEmpty),
      ), //example: Stubs.emptyList
      scenario: 'hotel_favorites_empty',
    ),
    buildScenario(
      widget: hotelFavoritesFactory(
          favoriteHotelsResult:
              Result.success(Stub.paginatedListHotelThreeAndOne),
          initFavoriteHotels:
              Stub.paginatedListHotelThreeAndOne), //example:  Stubs.success
      scenario: 'hotel_favorites_success',
      customPumpBeforeTest: animationCustomPump,
    ),
    buildScenario(
      widget: hotelFavoritesFactory(
        favoriteHotelsResult: Result.loading(),
      ), //loading
      scenario: 'hotel_favorites_loading',
      customPumpBeforeTest: animationCustomPump,
    ),
    buildScenario(
      widget: hotelFavoritesFactory(
        favoriteHotelsResult: Result.error(Stub.paginatedListError.error!),
      ),
      scenario: 'hotel_favorites_error',
    )
  ]);
}
