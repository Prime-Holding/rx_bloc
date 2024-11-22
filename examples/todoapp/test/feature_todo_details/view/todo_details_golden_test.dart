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
      scenario: 'todo_details_empty',
      widget: todoDetailsFactory(todo: Result.success(Stubs.todoEmpty)),
    ),
    buildScenario(
      scenario: 'todo_details_success',
      widget: todoDetailsFactory(todo: Result.success(Stubs.todoCompleted)),
    ),
    buildScenario(
      scenario: 'todo_details_bulk_action_loading',
      widget: todoDetailsFactory(
        todo: Result.success(Stubs.todoIncomplete),
        isLoading: true,
      ),
    ),
    buildScenario(
      scenario: 'todo_details_loading',
      widget: todoDetailsFactory(todo: Result.loading()),
    ),
    buildScenario(
      scenario: 'todo_details_error',
      widget: todoDetailsFactory(
        todo: Result.error(
          UnknownErrorModel(exception: Exception('Something went wrong')),
        ),
      ),
    ),
  ]);

  runUiComponentGoldenTests(
      scenario: 'todo_list_success_checkbox_onTap',
      size: const Size(600, 1000),
      children: [
        SizedBox(
          key: const Key('listtile_widget_tap'),
          height: 400,
          child: todoDetailsFactory(
            isLoading: false,
            todo: Result.success(Stubs.todoCutomId),
          ),
        )
      ],
      act: (tester) async {
        await tester.pumpAndSettle();
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
      });
}
