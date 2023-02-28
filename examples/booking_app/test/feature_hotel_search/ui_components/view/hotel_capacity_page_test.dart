import 'package:booking_app/feature_hotel_search/ui_components/hotel_capacity_page.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      scenario: Scenario(name: 'hotel_capacity_page'),
      widget: HotelCapacityPage(
          onApplyPressed: (i1, i2) {}), //example: Stubs.emptyList
    ),
  ]);
}
