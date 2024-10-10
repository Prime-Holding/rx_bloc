import 'package:favorites_advanced_base/keys.dart' as keys;
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../base/base_page.dart';
import '../base/utils.dart';

class HotelSearchObjPage extends BasePage {
  HotelSearchObjPage(super.$);

  @override
  Future<void> isPageLoaded() async {
    await checkPageVisibility(keys.searchPageKey);
  }

  Future<void> scrollUp() async {
    final listWidget = $(keys.searchPageListKey);

    await $.tester.fling(listWidget, const Offset(0, 300), 1000);

    await $.tester.pumpAndSettle();
  }

  Future<void> scrollDown() async {
    final listWidget = $(keys.searchPageListKey);

    await $.tester.timedDrag(
      listWidget,
      const Offset(0, -260),
      const Duration(seconds: 1),
    );

    await $.tester.pumpAndSettle();
  }

  Future<void> scrollToEndOfList() async {
    final listWidget = $(keys.searchPageListKey);

    await $.tester.fling(listWidget, const Offset(0, -800), 8000);
  }

  Future<void> tapSortFilter() async {
    await tapWidget(keys.sortFilterTapKey);
  }

  Future<void> applySortFilter() async {
    await tapWidget(keys.sortFilterApplyTapKey);
  }

  Future<void> setSortFilterType(SortBy type) async {
    await tapWidget(keys.sortTypeTapKey(type));
  }

  Future<void> tapDateFilter() async {
    await tapWidget(keys.dateFilterTapKey);
  }

  Future<void> applyDateFilter() async {
    await tapWidget('Apply');
  }

  Future<void> setDayFilter(int day) async {
    await tapWidget('$day');
  }

  bool isErrorWidgetVisible() => isWidgetVisible(keys.errorRetryWidgetKey);

  Future<void> tapErrorRetryButton() => tapWidget(keys.errorRetryTapKey);

  Future<void> setSearchText(String searchText) async {
    await setText(keys.searchFieldKey, searchText);
    await Future.delayed(const Duration(seconds: 2));
    await $.tester.pumpAndSettle();
  }

  Future<void> tapCapacityFilter() => tapWidget(keys.capacityFilterTapKey);

  Future<void> applyCapacityFilter() =>
      tapWidget(keys.capacityFilterApplyTapKey);

  Future<void> addRoomCapacity() =>
      tapWidget(keys.setCapacityFilterActionKey('Room capacity Add'));
  Future<void> removeRoomCapacity() =>
      tapWidget(keys.setCapacityFilterActionKey('Room capacity Remove'));

  Future<void> addPersonCount() =>
      tapWidget(keys.setCapacityFilterActionKey('Person count Add'));
  Future<void> removePersonCount() =>
      tapWidget(keys.setCapacityFilterActionKey('Person count Remove'));

  Future<void> enableNetworkAndRetry() async {
    await Utils.enableNetwork($);
    await tapErrorRetryButton();
  }
}
