import 'package:mockito/annotations.dart';
import 'package:todoapp/lib_todo_actions/services/todo_actions_service.dart';

import 'todo_action_service_mock.mocks.dart';

@GenerateMocks([
  TodoActionsService,
])
MockTodoActionsService todoActionsServiceMockFactory() =>
    MockTodoActionsService();
