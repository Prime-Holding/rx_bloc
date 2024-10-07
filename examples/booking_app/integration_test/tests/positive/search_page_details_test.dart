import 'package:favorites_advanced_base/keys.dart' as keys;
import 'package:flutter/material.dart';

import '../../integration_test_framework/base/utils.dart';
import '../../integration_test_framework/configuration/build_app.dart';
import '../../integration_test_framework/configuration/patrol_base_config.dart';
import '../../integration_test_framework/page_objects/home_obj_page.dart';
import '../../integration_test_framework/page_objects/hotel_details_obj_page.dart';
import '../../integration_test_framework/page_objects/hotel_search_obj_page.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    'Search Page - Details',
    ($) async {
      await Utils.setUpApp($);

      final homePage = HomeObjPage($);
      final searchPage = HotelSearchObjPage($);
      final detailsPage = HotelDetailsObjPage($);
      await searchPage.isPageLoaded();

      // check details & favorite
      await homePage.tapHotelListItem('0-1');
      await detailsPage.isPageLoaded();
      detailsPage.verifyAppShimmerWidgetTextContains(
        keys.detailsDescriptionKey,
        'We speak your language!',
      );

      await detailsPage.tapDetailsFavoriteButton('0-1');
      await detailsPage.tapDetailsBackButton();
      expect(homePage.isHotelFavorited(), true);
      ScaffoldMessenger.of(homePage.context).clearSnackBars();

      await homePage.tapFavoritesPageButton();
      expect(homePage.isListItemVisible('0-1'), true);

      // unfavorite
      await homePage.tapSearchPageButton();
      await homePage.tapHotelListItem('0-1');
      await detailsPage.tapDetailsFavoriteButton('0-1');
      await detailsPage.tapDetailsBackButton();
      expect(homePage.isHotelFavorited(), false);
      ScaffoldMessenger.of(homePage.context).clearSnackBars();

      await homePage.tapFavoritesPageButton();
      expect(homePage.isListItemVisible('0-1'), false);
    },
  );
}
