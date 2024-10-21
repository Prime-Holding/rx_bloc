import '../../integration_test_framework/base/utils.dart';
import '../../integration_test_framework/configuration/build_app.dart';
import '../../integration_test_framework/configuration/patrol_base_config.dart';
import '../../integration_test_framework/page_objects/home_obj_page.dart';
import '../../integration_test_framework/page_objects/hotel_details_obj_page.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();

  patrolBaseConfig.patrol(
    'Home Page - Favorite & Unfavorite',
    ($) async {
      final homePage = HomeObjPage($);
      final detailsPage = HotelDetailsObjPage($);

      await Utils.setUpApp($);

      /// favorite & unfavorite from search page
      await homePage.tapHotelFavoriteButton('0-1');
      expect(homePage.isHotelFavorited(), true);
      await homePage.tapHotelFavoriteButton('0-1');
      expect(homePage.isHotelFavorited(), false);

      await homePage.tapHotelFavoriteButton('0-1');
      expect(homePage.isHotelFavorited(), true);

      /// unfavorite from favorites page
      await homePage.tapFavoritesPageButton();
      await homePage.tapHotelFavoriteButton('0-1');
      expect(homePage.isHotelFavorited(), false);

      await homePage.tapSearchPageButton();
      await homePage.tapHotelFavoriteButton('0-1');
      expect(homePage.isHotelFavorited(), true);

      /// unfavorite from favorites details page
      await homePage.tapFavoritesPageButton();
      expect(homePage.isHotelFavorited(), true);
      expect(homePage.isListItemVisible('0-1'), true);

      await homePage.tapHotelListItem('0-1');
      await detailsPage.isPageLoaded();

      await detailsPage.tapDetailsFavoriteButton('0-1');
      await detailsPage.tapDetailsBackButton();
      expect(homePage.isHotelFavorited(), false);
      expect(homePage.isListItemVisible('0-1'), false);
    },
  );
}
