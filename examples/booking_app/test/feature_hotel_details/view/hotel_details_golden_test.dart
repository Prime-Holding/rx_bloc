import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../../stubs.dart';
import '../factory/hotel_details_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      widget: hotelDetailsFactory(
        hotel: Stub.hotel1,
      ), //example: Stubs.emptyList
      scenario: Scenario(
        name: 'hotel_details_loading',
      ),
    ),
    generateDeviceBuilder(
      widget: hotelDetailsFactory(
        hotel: Stub.hotel1Loaded,
      ), //example: Stubs.emptyList
      scenario: Scenario(
        name: 'hotel_details_loaded',
      ),
    ),
  ]);
}
