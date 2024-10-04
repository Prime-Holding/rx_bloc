import 'package:flutter/material.dart';
import 'package:todoapp/base/common_ui_components/todo_widget.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/keys.dart';

import '../base/base_page.dart';
import '../configuration/build_app.dart';

class TodoListPage extends BasePage {
  TodoListPage(super.$);

  PatrolFinder get locBtnAddTodo => $(K.todoListPageCreateButton);
  PatrolFinder get locBtnFilter => $(K.filtersButton);
  PatrolFinder get locBtnStatistics => $(Icons.show_chart);

  Future<void> tapBtnStatistics() async {
    await $.tester.pumpAndSettle();
    await $(locBtnStatistics).tap(settlePolicy: SettlePolicy.settle);
  }

  Future<void> tapBtnAddTodo() async {
    await $(locBtnAddTodo).tap(settlePolicy: SettlePolicy.settle);
  }

  Future<void> tapTodoListTile(int index) async {
    await $(K.todosList).$(TodoWidget).at(index).$(Text).tap();
  }

  Future<void> tapTodoCheckbox(int index) async {
    await $(K.todosList).$(Checkbox).at(index).tap();
  }

  Future<void> tapBtnFilter() async {
    await $(locBtnFilter).tap();
  }

  Future<void> tapFilterItem(TodosFilterModel filter) async {
    await $(K.filterByName(filter)).tap();
  }
}
