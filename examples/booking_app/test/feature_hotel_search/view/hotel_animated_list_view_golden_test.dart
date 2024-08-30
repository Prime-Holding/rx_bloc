import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../../stubs.dart';
import '../factory/hotel_animated_list_view_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      scenario: Scenario(name: 'hotel_animated_list_view_empty'),
      widget: hotelAnimatedListViewFactory(
        hotels: Stub.paginatedListEmpty,
      ),
    ),
    generateDeviceBuilder(
      scenario: Scenario(name: 'hotel_animated_list_view_with_hotels'),
      widget: hotelAnimatedListViewFactory(
        hotels: Stub.paginatedListTwoHotels,
      ),
    ),
    generateDeviceBuilder(
      scenario: Scenario(name: 'hotel_animated_list_view_error'),
      widget: hotelAnimatedListViewFactory(
        hotels: Stub.paginatedListError,
      ),
    ),
  ]);
}
