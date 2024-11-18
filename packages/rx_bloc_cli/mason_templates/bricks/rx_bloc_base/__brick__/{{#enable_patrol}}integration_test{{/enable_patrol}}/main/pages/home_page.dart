{{> licence.dart }}

import 'package:flutter/material.dart';

import '../base/base_page.dart';
import '../configuration/build_app.dart';{{#has_authentication}}
import 'profile_page.dart';{{/has_authentication}}

class HomePage extends BasePage {
  HomePage(super.$);

  {{#enable_feature_counter}}
  PatrolFinder get locBtnCounterPage => $(Icons.calculate);{{/enable_feature_counter}}{{#has_authentication}}
  PatrolFinder get locBtnProfilePage => $(Icons.account_box);{{/has_authentication}}{{#enable_feature_qr_scanner}}
  PatrolFinder get locBtnQrScannerPage => $(Icons.qr_code_scanner);{{/enable_feature_qr_scanner}}{{#has_showcase}}
  PatrolFinder get locBtnShowcasePage => $(Icons.shelves);{{/has_showcase}}{{#enable_feature_counter}}

  Future<void> tapBtnCounterPage() async {
    await $(locBtnCounterPage).tap();
    await $.pumpAndSettle();
  }{{/enable_feature_counter}} {{#has_showcase}}
  
    Future<void> tapBtnShowcasePage() async {
    await $(locBtnShowcasePage).tap();
    await $.pumpAndSettle();
  }{{/has_showcase}}{{#has_authentication}}

  Future<ProfilePage> tapBtnProfilePage() async {
    await $(locBtnProfilePage).tap();
    await $.pumpAndSettle();
    return ProfilePage($);
  }{{/has_authentication}}{{#enable_feature_qr_scanner}}

    Future<void> tapBtnQrScannerPage() async {
    await $(locBtnQrScannerPage).tap(settlePolicy: SettlePolicy.noSettle);
    } {{/enable_feature_qr_scanner}}
}
