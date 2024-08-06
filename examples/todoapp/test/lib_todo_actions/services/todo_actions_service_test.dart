import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:todoapp/base/repositories/todo_repository.dart';
import 'package:todoapp/lib_todo_actions/services/todo_actions_service.dart';

import '../../stubs.dart';
import 'todo_actions_service_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  group('TodoActionsService', () {
    late MockTodoRepository todoRepository;
    late TodoActionsService todoActionsService;

    setUp(() {
      todoRepository = MockTodoRepository();
      todoActionsService = TodoActionsService(todoRepository);
    });

    test('deleteTodoById should return the deleted todo', () async {
      when(todoRepository.fetchTodoById('1'))
          .thenAnswer((_) => Future.value(Stubs.todoCompleted));
      when(todoRepository.deleteTodoById('1'))
          .thenAnswer((_) => Future.value().then((_) => Stubs.todoCompleted));

      final result = await todoActionsService.deleteTodoById('1');

      expect(result, Stubs.todoCompleted);
    });

    test('updateCompletedById should return the updated todo', () async {
      when(todoRepository.updateCompletedById('1', true))
          .thenAnswer((_) => Future.value(Stubs.todoCompleted));

      final result = await todoActionsService.updateCompletedById('1', true);

      expect(result, Stubs.todoCompleted);
    });
  });
}
