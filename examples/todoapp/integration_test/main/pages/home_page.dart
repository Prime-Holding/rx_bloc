import 'package:flutter/material.dart';

import '../base/base_page.dart';
import '../configuration/build_app.dart';

class HomePage extends BasePage {
  HomePage(super.$);
  PatrolFinder get locBtnStatistics => $(Icons.show_chart);
  PatrolFinder get locBtnTodoList => $(Icons.list);

  Future<void> tapBtnStatistics() async {
    await $(locBtnStatistics).tap(settlePolicy: SettlePolicy.settle);
  }

  Future<void> tapBtnTodoList() async {
    await $(locBtnTodoList).tap(settlePolicy: SettlePolicy.settle);
  }
}
