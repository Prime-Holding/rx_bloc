import 'package:todoapp/keys.dart';
import 'package:todoapp/lib_todo_actions/models/bulk_action.dart';

import '../base/base_page.dart';
import '../configuration/build_app.dart';

class LibTodoActionsPage extends BasePage {
  LibTodoActionsPage(super.$);

  PatrolFinder get locBtnActions => $(K.actionsButton);

  Future<void> tapBtnActions() async {
    await $(locBtnActions).tap(settlePolicy: SettlePolicy.settle);
  }

  Future<void> tapActionItem(BulkActionModel action) async {
    await $(K.actionByName(action)).tap();
  }
}
