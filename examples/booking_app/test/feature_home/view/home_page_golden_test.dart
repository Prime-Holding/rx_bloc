import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/home_page_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'home_page_search_golden_test',
      widget: homePageFactory(
          navigationType: Stub.searchNavItemType), //example: Stubs.emptyList
      customPumpBeforeTest: animationCustomPump,
    ),
  ]);
}
