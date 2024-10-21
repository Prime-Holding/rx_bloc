import '../../integration_test_framework/base/utils.dart';
import '../../integration_test_framework/configuration/build_app.dart';
import '../../integration_test_framework/configuration/patrol_base_config.dart';
import '../../integration_test_framework/page_objects/home_obj_page.dart';
import '../../integration_test_framework/page_objects/hotel_search_obj_page.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    'Search Page - Fetch More',
    ($) async {
      await Utils.setUpApp($);

      final homePage = HomeObjPage($);
      final searchPage = HotelSearchObjPage($);
      await searchPage.isPageLoaded();

      /// scroll to end of list to check more details fetch
      await searchPage.scrollToEndOfList();
      await $.tester.pumpAndSettle();
      expect(homePage.isHotelListItemVisible('0-10'), true);

      /// scroll further to check pagination
      await searchPage.scrollToEndOfList();
      await Future.delayed(const Duration(seconds: 1));
      await $.tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      await searchPage.scrollDown();
      await $.tester.pumpAndSettle();
      expect(homePage.isHotelListItemVisible('0-11'), true);
    },
  );
}
