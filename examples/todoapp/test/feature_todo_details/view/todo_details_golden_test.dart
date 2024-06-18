import 'package:rx_bloc/rx_bloc.dart';

import '../../Stubs.dart';
import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/todo_details_factory.dart';


void main() {
  runGoldenTests([
    
    generateDeviceBuilder(
        widget: todoDetailsFactory(todo: Result.success(Stubs.todoEmpty)),
        scenario: Scenario(name: 'todo_details_empty')),
    generateDeviceBuilder(
        widget: todoDetailsFactory(todo: Result.success(Stubs.todoUncompleted)), //example:  Stubs.success
        scenario: Scenario(name: 'todo_details_success')),
    generateDeviceBuilder(
        widget: todoDetailsFactory(todo: Result.loading()), //loading
        scenario: Scenario(name: 'todo_details_loading')),
    generateDeviceBuilder(
        widget: todoDetailsFactory(todo: Result.error(Exception('Something went wrong'))),
        scenario: Scenario(name: 'todo_details_error'))
  ]);
}
