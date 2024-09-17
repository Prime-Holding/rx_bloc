import 'package:rx_bloc/rx_bloc.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../../stubs.dart';
import '../factory/todo_list_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: todoListFactory(
            todoList: Result.success(Stubs.todoListEmpty),
            filter: TodosFilterModel.all),
        scenario: Scenario(name: 'todo_list_empty')),
    generateDeviceBuilder(
        widget: todoListFactory(
            todoList: Result.success(Stubs.todoList),
            filter: TodosFilterModel.all),
        scenario: Scenario(name: 'todo_list_success')),
    generateDeviceBuilder(
        widget: todoListFactory(
            todoList: Result.loading(), filter: TodosFilterModel.all),
        scenario: Scenario(name: 'todo_list_loading')),
    generateDeviceBuilder(
      widget: todoListFactory(
        isLoading: true,
        todoList: Result.success(Stubs.todoList),
        filter: TodosFilterModel.all,
      ),
      scenario: Scenario(name: 'todo_list_bulk_action_loading'),
    ),
    generateDeviceBuilder(
        widget: todoListFactory(
            todoList: Result.error(UnknownErrorModel(
                exception: Exception('Something went wrong'))),
            filter: TodosFilterModel.all),
        scenario: Scenario(name: 'todo_list_error'))
  ]);
}
