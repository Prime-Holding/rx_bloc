{{> licence.dart }}

import 'package:flutter/material.dart';

import '../base/base_page.dart';
import '../configuration/build_app.dart';

class ProfilePage extends BasePage {
  ProfilePage(PatrolTester $) : super($);

  final Finder locBtnLogout = find.byIcon(Icons.logout);

  Future<void> tapBtnLogout() async {
    await $(locBtnLogout).tap();
  }
}
