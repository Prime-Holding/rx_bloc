{{> licence.dart }}

import '../configuration/build_app.dart';
import '../pages/home_page.dart';

class HomePageSteps {
  {{#enable_feature_counter}}
  static Future<void> navigateToCounterPage(PatrolIntegrationTester $) async {
    HomePage homePage = HomePage($);
    await homePage.tapBtnCounterPage();
    // TODO: Implement steps here
  }
  {{/enable_feature_counter}}{{^enable_feature_counter}}
}
