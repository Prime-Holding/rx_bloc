import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:todoapp/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/todo_details_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
        widget: todoDetailsFactory(todo: Result.success(Stubs.todoEmpty)),
        scenario: 'todo_details_empty'),
    buildScenario(
        widget: todoDetailsFactory(todo: Result.success(Stubs.todoCompleted)),
        scenario: 'todo_details_success'),
    buildScenario(
        customPumpBeforeTest: animationCustomPump,
        widget: todoDetailsFactory(
          todo: Result.success(Stubs.todoIncomplete),
          isLoading: true,
        ),
        scenario: 'todo_details_bulk_action_loading'),
    buildScenario(
        widget: todoDetailsFactory(todo: Result.loading()),
        scenario: 'todo_details_loading'),
    buildScenario(
        widget: todoDetailsFactory(
            todo: Result.error(UnknownErrorModel(
                exception: Exception('Something went wrong')))),
        scenario: 'todo_details_error'),
  ]);
  //
  runUiComponentGoldenTests(
      scenario: 'todo_list_success_checkbox_onTap',
      size: const Size(600, 1000),
      children: [
        buildScenario(
          scenario: 'listtile_widget_tap',
          widget: SizedBox(
            height: 400,
            child: todoDetailsFactory(
              isLoading: false,
              todo: Result.success(Stubs.todoCutomId),
            ),
          ),
        ),
      ],
      act: (tester) async {
        await tester.pumpAndSettle();
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
      });
}
