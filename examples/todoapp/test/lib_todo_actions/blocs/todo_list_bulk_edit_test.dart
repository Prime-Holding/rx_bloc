import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/lib_todo_actions/blocs/todo_list_bulk_edit_bloc.dart';
import 'package:todoapp/lib_todo_actions/services/todo_actions_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import 'todo_action_service_mock.dart';

Future<void> main() async {
  late CoordinatorBlocType _coordinatorBloc;
  late TodoActionsService _service;

  void _defineWhen() {}

  TodoListBulkEditBloc bloc() => TodoListBulkEditBloc(
        _service,
        _coordinatorBloc,
      );

  setUp(() {
    _service = todoActionsServiceMockFactory();
    _coordinatorBloc = coordinatorBlocMockFactory();
  });
}
