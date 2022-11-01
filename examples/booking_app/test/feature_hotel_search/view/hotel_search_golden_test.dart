import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../../stubs.dart';
import '../factory/hotel_search_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      scenario: Scenario(name: 'hotel_search_empty'),
      widget: hotelSearchFactory(
        hotels: Stub.paginatedListEmpty,
      ), //example: Stubs.emptyList
    ),
    generateDeviceBuilder(
      scenario: Scenario(name: 'hotel_search_success'),
      widget: hotelSearchFactory(
        hotels: Stub.paginatedListHotelThree,
        capacityFilterData: Stub.capacityFilterDataTwoPersonsOneRoom,
        dateRangeFilterData: Stub.dateRangeFilterData,
      ), //example:  Stubs.success
    ),
    generateDeviceBuilder(
        widget: hotelSearchFactory(
          hotels: Stub.paginatedListEmptyLoading,
        ), //loading
        scenario: Scenario(name: 'hotel_search_loading')),
    generateDeviceBuilder(
        widget: hotelSearchFactory(
          hotels: Stub.paginatedListError,
        ),
        scenario: Scenario(name: 'hotel_search_error'))
  ]);
}
