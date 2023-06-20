{{> licence.dart }}

import 'package:flutter/material.dart';

import '../base/base_page.dart';
import '../configuration/build_app.dart';{{#has_authentication}}
import 'profile_page.dart';{{/has_authentication}}

class HomePage extends BasePage {
  HomePage(PatrolTester $) : super($);

  {{#enable_feature_counter}}
  PatrolFinder get locBtnCounterPage => $(Icons.calculate);{{/enable_feature_counter}}{{#has_authentication}}
  PatrolFinder get locBtnProfilePage => $(Icons.account_box);{{/has_authentication}}{{#enable_feature_counter}}

  Future<void> tapBtnCounterPage() async {
    await $(locBtnCounterPage).tap();
  }{{/enable_feature_counter}}{{#has_authentication}}

  Future<ProfilePage> tapBtnProfilePage() async {
    await $(locBtnProfilePage).tap();
    return ProfilePage($);
  }{{/has_authentication}}
}
