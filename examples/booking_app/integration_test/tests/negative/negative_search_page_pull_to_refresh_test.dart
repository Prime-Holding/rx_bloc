import '../../integration_test_framework/base/utils.dart';
import '../../integration_test_framework/configuration/build_app.dart';
import '../../integration_test_framework/configuration/patrol_base_config.dart';
import '../../integration_test_framework/page_objects/hotel_search_obj_page.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    'Search Page - Pull to refresh - Network error',
    ($) async {
      await Utils.setUpApp($);

      final searchPage = HotelSearchObjPage($);
      await searchPage.isPageLoaded();

      /// disable network & pull to refresh
      Utils.disableNetwork($);
      await searchPage.scrollUp();
      expect(searchPage.isErrorWidgetVisible(), true);

      await searchPage.enableNetworkAndRetry();
    },
  );
}
