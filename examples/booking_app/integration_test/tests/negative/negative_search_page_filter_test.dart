import 'package:favorites_advanced_base/models.dart';

import '../../integration_test_framework/base/utils.dart';
import '../../integration_test_framework/configuration/build_app.dart';
import '../../integration_test_framework/configuration/patrol_base_config.dart';
import '../../integration_test_framework/page_objects/hotel_search_obj_page.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    'Search Page - Filters - Network Error',
    ($) async {
      await Utils.setUpApp($);

      final searchPage = HotelSearchObjPage($);
      await searchPage.isPageLoaded();

      // region: search
      Utils.disableNetwork($);
      await searchPage.setSearchText('hotel');
      await Future.delayed(const Duration(seconds: 1));
      expect(searchPage.isErrorWidgetVisible(), true);
      await searchPage.enableNetworkAndRetry();
      // endregion

      // region: room capacity
      Utils.disableNetwork($);
      await searchPage.tapCapacityFilter();
      await searchPage.addRoomCapacity();
      await searchPage.applyCapacityFilter();
      expect(searchPage.isErrorWidgetVisible(), true);
      await searchPage.enableNetworkAndRetry();
      // endregion

      // region: person count
      Utils.disableNetwork($);
      await searchPage.tapCapacityFilter();
      await searchPage.removeRoomCapacity();
      await searchPage.addPersonCount();
      await searchPage.applyCapacityFilter();
      expect(searchPage.isErrorWidgetVisible(), true);
      await searchPage.enableNetworkAndRetry();
      // endregion

      // region: reset capacity
      Utils.disableNetwork($);
      await searchPage.tapCapacityFilter();
      await searchPage.removePersonCount();
      await searchPage.applyCapacityFilter();
      expect(searchPage.isErrorWidgetVisible(), true);
      await searchPage.enableNetworkAndRetry();
      // endregion

      // region: sort - price descending
      Utils.disableNetwork($);
      await searchPage.tapSortFilter();
      await searchPage.setSortFilterType(SortBy.priceDesc);
      await searchPage.applySortFilter();
      expect(searchPage.isErrorWidgetVisible(), true);
      await searchPage.enableNetworkAndRetry();
      // endregion

      // region: sort - price ascending
      Utils.disableNetwork($);
      await searchPage.tapSortFilter();
      await searchPage.setSortFilterType(SortBy.priceAsc);
      await searchPage.applySortFilter();
      expect(searchPage.isErrorWidgetVisible(), true);
      await searchPage.enableNetworkAndRetry();
      // endregion

      // region: sort - distance ascending
      Utils.disableNetwork($);
      await searchPage.tapSortFilter();
      await searchPage.setSortFilterType(SortBy.distanceAsc);
      await searchPage.applySortFilter();
      expect(searchPage.isErrorWidgetVisible(), true);
      await searchPage.enableNetworkAndRetry();
      // endregion

      // region: sort - distance descending
      Utils.disableNetwork($);
      await searchPage.tapSortFilter();
      await searchPage.setSortFilterType(SortBy.distanceDesc);
      await searchPage.applySortFilter();
      expect(searchPage.isErrorWidgetVisible(), true);
      await searchPage.enableNetworkAndRetry();
      // endregion

      // region: date
      Utils.disableNetwork($);
      await searchPage.tapDateFilter();
      await searchPage.setDayFilter(27);
      await searchPage.setDayFilter(28);
      await searchPage.applyDateFilter();
      expect(searchPage.isErrorWidgetVisible(), true);
      await searchPage.enableNetworkAndRetry();
      // endregion
    },
  );
}
