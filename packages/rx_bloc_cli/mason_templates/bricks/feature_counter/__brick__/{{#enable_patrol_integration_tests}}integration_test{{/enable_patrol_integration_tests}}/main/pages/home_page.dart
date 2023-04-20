import 'package:flutter/material.dart';

import '../base/common.dart';
import 'base_page.dart';

class HomePagePatrol extends BasePagePatrol {
  HomePagePatrol(PatrolTester tester) : super(tester);

  final Finder locBtnCounterPage = find.byIcon(Icons.calculate);
  final Finder locBtnProfilePage = find.byIcon(Icons.account_box);
  Future<void> tapBtnCalcPage() async {
    await tapElement(locBtnCounterPage);
  }

  Future<void> tapBtnProfilePage() async {
    await tapElement(locBtnProfilePage);
  }
}
