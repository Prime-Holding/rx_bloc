import 'package:testapp/keys.dart';

import '../base/common.dart';
import 'base_page.dart';

class LoginPagePatrol extends BasePagePatrol {
  LoginPagePatrol(PatrolTester tester) : super(tester);

  final Finder locInputEmail = find.byKey(K.loginEmail);
  final Finder locInputPassword = find.byKey(K.loginPassword);
  final Finder locLoginButton = find.byKey(K.loginButton);

  Future<void> setTextEmail() async {
    await setText(locInputEmail, 'admin@email.com');
  }

  Future<void> setTextPassword() async {
    await setText(locInputPassword, '123456');
  }

  Future<void> tapLoginButton() async {
    await tapElement(locLoginButton);
  }
}
