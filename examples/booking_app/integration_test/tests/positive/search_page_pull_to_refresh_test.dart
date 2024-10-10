import '../../integration_test_framework/base/utils.dart';
import '../../integration_test_framework/configuration/build_app.dart';
import '../../integration_test_framework/configuration/patrol_base_config.dart';
import '../../integration_test_framework/page_objects/home_obj_page.dart';
import '../../integration_test_framework/page_objects/hotel_search_obj_page.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    'Search Page - Pull to refresh',
    ($) async {
      await Utils.setUpApp($);

      final homePage = HomeObjPage($);
      final searchPage = HotelSearchObjPage($);
      await searchPage.isPageLoaded();

      /// pull to refresh & check if successful
      await searchPage.scrollUp();
      expect(homePage.isHotelListItemVisible('0-1'), true);
    },
  );
}
