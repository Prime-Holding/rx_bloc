import 'package:booking_app/feature_hotel_search/ui_components/hotel_sort_page.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      scenario: Scenario(name: 'hotel_sort_page'),
      widget: const HotelSortPage(), //example: Stubs.emptyList
    ),
  ]);
}
