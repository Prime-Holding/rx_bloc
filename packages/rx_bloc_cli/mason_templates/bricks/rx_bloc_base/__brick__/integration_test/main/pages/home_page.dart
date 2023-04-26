{{> licence.dart }}

import 'package:flutter/material.dart';

import '../base/base_page.dart';
import '../configuration/build_app.dart';
import 'profile_page.dart';

class HomePage extends BasePage {
  HomePage(PatrolTester $) : super($);

  PatrolFinder get locBtnCounterPage => $(Icons.calculate);
  PatrolFinder get locBtnProfilePage => $(Icons.account_box);

  Future<void> tapBtnCounterPage() async {
    await $(locBtnCounterPage).tap();
  }

  Future<ProfilePage> tapBtnProfilePage() async {
    await $(locBtnProfilePage).tap();
    return ProfilePage($);
  }
}
