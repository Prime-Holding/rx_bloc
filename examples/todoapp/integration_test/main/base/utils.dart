// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:patrol/patrol.dart';

import '../steps_utils/todo_list_stepts.dart';
import '../steps_utils/todo_management_steps.dart';

abstract class Utils {
  late PatrolIntegrationTester $;

  Utils(this.$);

  /// Here some utility methods will be added during test implementation process
  ///
  static Future<void> addTodos(
      PatrolIntegrationTester $, int numberOfTodos) async {
    for (var i = 0; i < numberOfTodos; i++) {
      await TodoListSteps.navigateToAddTodoPage($);

      await TodoManagementSteps.enterTodoDescription($, 'Description $i');

      await TodoManagementSteps.enterTodoTitle($, 'Todo $i');

      await TodoManagementSteps.tapBtnAddTodo($);
    }
  }
}
