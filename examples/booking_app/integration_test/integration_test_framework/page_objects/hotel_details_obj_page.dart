import 'package:favorites_advanced_base/keys.dart' as keys;
import 'package:flutter_test/flutter_test.dart';

import '../base/base_page.dart';

class HotelDetailsObjPage extends BasePage {
  HotelDetailsObjPage(super.$);

  @override
  Future<void> isPageLoaded() async {
    await checkPageVisibility(keys.detailsPageKey);
  }

  Future<void> tapDetailsBackButton() async {
    await tapWidget(keys.detailsBackButton);
  }

  Future<void> tapDetailsFavoriteButton(String id) async {
    await tapWidget(keys.detailsFavoriteButtonById(id));
  }

  void verifyWidgetContainsText(var widget, String expectedText) =>
      expect($(widget).text?.contains(expectedText), true);
}
