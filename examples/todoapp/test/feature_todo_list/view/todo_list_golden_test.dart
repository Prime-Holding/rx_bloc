import 'package:rx_bloc/rx_bloc.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';

import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/todo_list_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'todo_list_empty',
      widget: todoListFactory(
          todoList: Result.success(Stubs.todoListEmpty),
          filter: TodosFilterModel.all),
    ),
    buildScenario(
      scenario: 'todo_list_success',
      widget: todoListFactory(
          todoList: Result.success(Stubs.todoList),
          filter: TodosFilterModel.all),
    ),
    buildScenario(
      scenario: 'todo_list_loading',
      customPumpBeforeTest: animationCustomPump,
      widget: todoListFactory(
        todoList: Result.loading(),
        filter: TodosFilterModel.all,
      ),
    ),
    buildScenario(
      customPumpBeforeTest: animationCustomPump,
      scenario: 'todo_list_bulk_action_loading',
      widget: todoListFactory(
        isLoading: true,
        todoList: Result.success(Stubs.todoList),
        filter: TodosFilterModel.all,
      ),
    ),
    buildScenario(
      scenario: 'todo_list_error',
      widget: todoListFactory(
        todoList: Result.error(
          UnknownErrorModel(exception: Exception('Something went wrong')),
        ),
        filter: TodosFilterModel.all,
      ),
    ),
  ]);
}
