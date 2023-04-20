import 'package:flutter/material.dart';

import '../base/common.dart';
import 'base_page.dart';

class ProfilePagePatrol extends BasePagePatrol {
  ProfilePagePatrol(PatrolTester tester) : super(tester);

  final Finder locBtnLogout = find.byIcon(Icons.logout);

  Future<void> tapBtnLogout() async {
    await tapElement(locBtnLogout);
  }
}
