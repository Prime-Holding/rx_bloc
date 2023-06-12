{{> licence.dart }}

import 'package:patrol/patrol.dart';
import 'package:{{project_name}}/keys.dart';

import '../base/base_page.dart';

class LoginPage extends BasePage {
  LoginPage(PatrolTester $) : super($);

  Future<void> setTextEmail(String email) async {
    await $(K.loginEmail).enterText(email);
  }

  Future<void> setTextPassword(String password) async {
    await $(K.loginPassword).enterText(password);
  }

  Future<void> tapLoginButton() async {
    await $(K.loginButton).tap();
  }
}
