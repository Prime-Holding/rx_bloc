import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/hotel_search_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'hotel_search_empty',
      widget: hotelSearchFactory(
        hotels: Stub.paginatedListEmpty,
      ), //example: Stubs.emptyList
    ),
    buildScenario(
      scenario: 'hotel_search_success',
      widget: hotelSearchFactory(
        hotels: Stub.paginatedListHotelThree,
        capacityFilterData: Stub.capacityFilterDataTwoPersonsOneRoom,
        dateRangeFilterData: Stub.dateRangeFilterData,
      ), //example:  Stubs.success
    ),
    buildScenario(
      widget: hotelSearchFactory(
        hotels: Stub.paginatedListEmptyLoading,
      ), //loading
      scenario: 'hotel_search_loading',
    ),
    buildScenario(
        widget: hotelSearchFactory(
          hotels: Stub.paginatedListError,
        ),
        scenario: 'hotel_search_error')
  ]);
}
