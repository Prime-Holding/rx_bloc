{{> licence.dart }}

import '../configuration/build_app.dart';
import '../pages/login_page.dart';

class LoginPageSteps {
  static Future<void> loginAction(PatrolTester $) async {
    LoginPage loginPage = LoginPage($);
    await loginPage.setTextEmail('admin@email.com');
    await loginPage.setTextPassword('123456');
    await loginPage.tapLoginButton();
  }
}
