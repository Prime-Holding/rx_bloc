import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/hotel_details_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      widget: hotelDetailsFactory(
        hotel: Stub.hotel1,
      ), //example: Stubs.emptyList
      scenario: 'hotel_details_loading',
    ),
    buildScenario(
      widget: hotelDetailsFactory(
        hotel: Stub.hotel1Loaded,
      ), //example: Stubs.emptyList
      scenario: 'hotel_details_loaded',
    ),
  ]);
}
