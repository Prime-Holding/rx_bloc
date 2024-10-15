import 'package:favorites_advanced_base/resources.dart' as keys;

import '../base/base_page.dart';

class HotelSearchObjPage extends BasePage {
  HotelSearchObjPage(super.$);

  @override
  Future<void> isPageLoaded() async {
    await checkPageVisibility(keys.favoritesPageKey);
  }

  Future<void> tapHotelFavoriteButton(String id) async {
    await tapWidget(keys.favoriteButtonById(id));
  }
}
