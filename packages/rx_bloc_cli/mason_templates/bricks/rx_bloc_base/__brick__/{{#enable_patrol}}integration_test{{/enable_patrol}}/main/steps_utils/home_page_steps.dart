{{> licence.dart }}

import '../configuration/build_app.dart';
import '../pages/home_page.dart';

class HomePageSteps {
  static Future<void> navigateToCounterPage(PatrolIntegrationTester $) async {
    HomePage homePage = HomePage($);{{#enable_feature_counter}}
    await homePage.tapBtnCounterPage();{{/enable_feature_counter}}{{^enable_feature_counter}}
    // TODO: Implement steps here{{/enable_feature_counter}}
  }
}
