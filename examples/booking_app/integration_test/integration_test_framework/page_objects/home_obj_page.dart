import 'package:favorites_advanced_base/resources.dart' as keys;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../base/base_page.dart';

class HomeObjPage extends BasePage {
  HomeObjPage(super.$);

  @override
  Future<void> isPageLoaded() async =>
      await checkPageVisibility(keys.homePageKey);

  BuildContext get context => $.tester.element(find.byType(Scaffold));

  void clearSnackBars() => ScaffoldMessenger.of(context).clearSnackBars();

  bool isListItemVisible(String id) => isWidgetVisible(keys.listItemById(id));

  String? getFavoriteButtonCount() => $(keys.favoritesNavButtonTextKey).text;

  bool isHotelFavorited() {
    final hasFavorites = isWidgetExists(keys.favoritesNavButtonTextKey);

    return hasFavorites ? getFavoriteButtonCount() == '1' : false;
  }

  Future<void> tapSearchPageButton() async {
    await tapWidget(keys.searchNavButtonKey);
  }

  Future<void> tapFavoritesPageButton() async {
    await tapWidget(keys.favoritesNavButtonTapKey);
  }

  bool isHotelListItemVisible(String id) {
    return isWidgetVisible(keys.listItemById(id));
  }

  Future<void> tapHotelFavoriteButton(String id) async {
    await tapWidget(keys.favoriteButtonById(id));
  }

  Future<void> tapHotelListItem(String id) async {
    await tapWidget(keys.listItemTapById(id));
  }

  Future<bool> isErrorSnackbarVisible() async {
    await Future.delayed(const Duration(seconds: 1));
    await $.tester.pumpAndSettle();
    return isWidgetVisible(keys.errorSnackbarKey);
  }
}
