{{> licence.dart }}

import '../configuration/build_app.dart';
import '../pages/home_page.dart';

class ProfilePageSteps {
  static Future<void> logout(PatrolTester $) async {
    HomePage homePage = HomePage($);
    final profilePage = await homePage.tapBtnProfilePage();

    await profilePage.tapBtnLogout();
  }
}
