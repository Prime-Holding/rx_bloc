import 'package:favorites_advanced_base/models.dart';

import '../../integration_test_framework/base/utils.dart';
import '../../integration_test_framework/configuration/build_app.dart';
import '../../integration_test_framework/configuration/patrol_base_config.dart';
import '../../integration_test_framework/page_objects/home_obj_page.dart';
import '../../integration_test_framework/page_objects/hotel_search_obj_page.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    'Search Page - Filters',
    ($) async {
      await Utils.setUpApp($);

      final homePage = HomeObjPage($);
      final searchPage = HotelSearchObjPage($);
      await searchPage.isPageLoaded();

      // region: search
      await searchPage.setSearchText('hotel');
      await Future.delayed(const Duration(seconds: 1));
      expect(homePage.isHotelListItemVisible('0-2'), true);
      await searchPage.scrollDown();
      expect(homePage.isHotelListItemVisible('0-5'), true);
      await searchPage.scrollUp();
      await searchPage.setSearchText('');
      expect(homePage.isHotelListItemVisible('0-1'), true);
      // endregion

      // region: room capacity
      await searchPage.tapCapacityFilter();
      await searchPage.addRoomCapacity();
      await searchPage.applyCapacityFilter();
      expect(homePage.isHotelListItemVisible('0-1'), true);
      await searchPage.scrollDown();
      expect(homePage.isHotelListItemVisible('0-4'), true);
      await searchPage.scrollUp();
      // endregion

      // region: person count
      await searchPage.tapCapacityFilter();
      await searchPage.removeRoomCapacity();
      await searchPage.addPersonCount();
      await searchPage.applyCapacityFilter();
      expect(homePage.isHotelListItemVisible('0-1'), true);
      await searchPage.scrollDown();
      expect(homePage.isHotelListItemVisible('0-2'), true);
      await searchPage.scrollUp();
      // endregion

      // region: reset capacity
      await searchPage.tapCapacityFilter();
      await searchPage.removePersonCount();
      await searchPage.applyCapacityFilter();
      expect(homePage.isHotelListItemVisible('0-1'), true);
      await searchPage.scrollDown();
      expect(homePage.isHotelListItemVisible('0-2'), true);
      await searchPage.scrollUp();
      // endregion

      // region: sort - price descending
      await searchPage.tapSortFilter();
      await searchPage.setSortFilterType(SortBy.priceDesc);
      await searchPage.applySortFilter();
      expect(homePage.isHotelListItemVisible('80-6'), true);
      await searchPage.scrollDown();
      expect(homePage.isHotelListItemVisible('0-6'), true);
      // endregion

      // region: sort - price ascending
      await searchPage.tapSortFilter();
      await searchPage.setSortFilterType(SortBy.priceAsc);
      await searchPage.applySortFilter();
      expect(homePage.isHotelListItemVisible('68-9'), true);
      expect(homePage.isHotelListItemVisible('12-9'), true);
      // endregion

      // region: sort - distance ascending
      await searchPage.tapSortFilter();
      await searchPage.setSortFilterType(SortBy.distanceAsc);
      await searchPage.applySortFilter();
      expect(homePage.isHotelListItemVisible('43-19'), true);
      expect(homePage.isHotelListItemVisible('99-19'), true);
      // endregion

      // region: sort - distance descending
      await searchPage.tapSortFilter();
      await searchPage.setSortFilterType(SortBy.distanceDesc);
      await searchPage.applySortFilter();
      expect(homePage.isHotelListItemVisible('71-2'), true);
      expect(homePage.isHotelListItemVisible('0-2'), true);
      await searchPage.scrollUp();
      // endregion

      // region: date
      await searchPage.tapDateFilter();
      await searchPage.setDayFilter(27);
      await searchPage.setDayFilter(28);
      await searchPage.applyDateFilter();
      // can't check for specific hotels since the result will vary by month
      searchPage.isWidgetExists('HotelListItem');
      // endregion
    },
  );
}
