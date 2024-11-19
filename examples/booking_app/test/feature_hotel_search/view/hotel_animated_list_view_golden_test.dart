import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/hotel_animated_list_view_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario:'hotel_animated_list_view_empty',
      widget: hotelAnimatedListViewFactory(
        hotels: Stub.paginatedListEmpty,
      ),
    ),
    buildScenario(
      scenario: 'hotel_animated_list_view_with_hotels',
      widget: hotelAnimatedListViewFactory(
        hotels: Stub.paginatedListTwoHotels,
      ),
    ),
    buildScenario(
      scenario: 'hotel_animated_list_view_error',
      widget: hotelAnimatedListViewFactory(
        hotels: Stub.paginatedListError,
      ),
    ),
  ]);
}
