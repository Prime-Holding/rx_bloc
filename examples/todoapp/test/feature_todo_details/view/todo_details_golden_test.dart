import 'package:rx_bloc/rx_bloc.dart';
import 'package:todoapp/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../../stubs.dart';
import '../factory/todo_details_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: todoDetailsFactory(todo: Result.success(Stubs.todoEmpty)),
        scenario: Scenario(name: 'todo_details_empty')),
    generateDeviceBuilder(
        widget: todoDetailsFactory(todo: Result.success(Stubs.todoIncomplete)),
        scenario: Scenario(name: 'todo_details_success')),
    generateDeviceBuilder(
      widget: todoDetailsFactory(
        todo: Result.success(Stubs.todoIncomplete),
        isLoading: true,
      ),
      scenario: Scenario(name: 'todo_details_bulk_action_loading'),
    ),
    generateDeviceBuilder(
        widget: todoDetailsFactory(todo: Result.loading()),
        scenario: Scenario(name: 'todo_details_loading')),
    generateDeviceBuilder(
        widget: todoDetailsFactory(
            todo: Result.error(UnknownErrorModel(
                exception: Exception('Something went wrong')))),
        scenario: Scenario(name: 'todo_details_error'))
  ]);
}
