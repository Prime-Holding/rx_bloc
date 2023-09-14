{{> licence.dart }}

import 'package:flutter/material.dart';

import '../base/base_page.dart';
import '../configuration/build_app.dart';{{#has_authentication}}
import 'profile_page.dart';{{/has_authentication}}

class HomePage extends BasePage {
  HomePage(PatrolIntegrationTester $) : super($);

  {{#enable_feature_counter}}
  PatrolFinder get locBtnCounterPage => $(Icons.calculate);{{/enable_feature_counter}}{{#has_authentication}}
  PatrolFinder get locBtnProfilePage => $(Icons.account_box);{{/has_authentication}}{{#enable_feature_counter}}

  Future<void> tapBtnCounterPage() async {
    await $(locBtnCounterPage).tap();
    await $.pumpAndSettle();
  }{{/enable_feature_counter}}{{#has_authentication}}

  Future<ProfilePage> tapBtnProfilePage() async {
    await $(locBtnProfilePage).tap();
    await $.pumpAndSettle();
    return ProfilePage($);
  }{{/has_authentication}}
}
