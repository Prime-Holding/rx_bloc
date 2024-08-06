import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todoapp/base/repositories/todo_repository.dart';
import 'package:todoapp/feature_todo_management/services/todo_manage_service.dart';

import '../../stubs.dart';
import 'todo_management_service_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  group('TodoManagementService tests', () {
    late TodoManageService todoManageService;
    late MockTodoRepository todoRepository;

    setUp(() {
      todoRepository = MockTodoRepository();
      todoManageService = TodoManageService(todoRepository);
    });

    test('addOrUpdateTodo updates todo based on the model provided', () async {
      when(todoRepository.updateTodoById('1', Stubs.todoCompleted))
          .thenAnswer((_) => Future.value(Stubs.todoCompleted));

      final result = await todoManageService.addOrUpdate(
        Stubs.todoCompleted,
      );

      expect(result, Stubs.todoCompleted);
    });

    test('addOrUpdateTodo adds a model when provided models id is null ',
        () async {
      when(todoRepository.addTodo(Stubs.todoEmpty.copyWith(title: 'test')))
          .thenAnswer(
              (_) => Future.value(Stubs.todoEmpty.copyWith(title: 'test')));

      final result = await todoManageService
          .addOrUpdate(Stubs.todoEmpty.copyWith(title: 'test'));

      expect(result, Stubs.todoEmpty.copyWith(title: 'test'));
    });
  });
}
