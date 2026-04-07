{{> licence.dart }}

{{#enable_feature_counter}}
import '../configuration/build_app.dart';
import '../pages/home_page.dart';
{{/enable_feature_counter}}

class HomePageSteps {
  {{#enable_feature_counter}}
  static Future<void> navigateToCounterPage(PatrolIntegrationTester $) async {
    HomePage homePage = HomePage($);
     await homePage.tapBtnShowcasePage();
    await homePage.tapBtnCounterPage();
    // TODO: Implement steps here
  }
  {{/enable_feature_counter}}{{#enable_feature_qr_scanner}}
    static Future<void> navigateToQrScannerPage(PatrolIntegrationTester $) async {
    HomePage homePage = HomePage($);
    await homePage.tapBtnShowcasePage();
    await homePage.tapBtnQrScannerPage();
  } {{/enable_feature_qr_scanner}}
}
