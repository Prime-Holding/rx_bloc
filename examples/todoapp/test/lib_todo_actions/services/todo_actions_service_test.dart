import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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

    group('TodoActionsService', () {
      test('deleteTodoById should delete and return the todo', () async {
        final todo = Stubs.todoIncomplete;
        when(todoRepository.fetchTodoById('1')).thenAnswer((_) async => todo);
        when(todoRepository.deleteTodoById('1')).thenAnswer((_) async => true);

        final result = await todoActionsService.deleteTodoById('1');

        expect(result, todo);
        verify(todoRepository.fetchTodoById('1')).called(1);
        verify(todoRepository.deleteTodoById('1')).called(1);
      });

      test('areAllCompleted should return true if all todos are completed', () {
        final todos = [
          Stubs.todoCompleted,
          Stubs.todoCompleted.copyWith(id: '2'),
        ];

        final result = todoActionsService.areAllCompleted(todos);

        expect(result, true);
      });

      test('areAllIncomplete should return true if all todos are incomplete',
          () {
        final todos = [
          Stubs.todoIncomplete,
          Stubs.todoIncomplete.copyWith(id: '2'),
        ];

        final result = todoActionsService.areAllIncomplete(todos);

        expect(result, true);
      });

      test('hasCompleted should return true if any todo is completed', () {
        final todos = [
          Stubs.todoIncomplete,
          Stubs.todoCompleted.copyWith(id: '2'),
        ];

        final result = todoActionsService.hasCompleted(todos);

        expect(result, true);
      });

      test(
          'updateCompletedForAll should update the completed status for all todos',
          () async {
        final todos = [
          Stubs.todoCompleted,
          Stubs.todoCompleted.copyWith(id: '2'),
        ];
        when(todoRepository.updateCompletedForAll(true))
            .thenAnswer((_) async => todos);

        final result =
            await todoActionsService.updateCompletedForAll(completed: true);

        expect(result, todos);
        verify(todoRepository.updateCompletedForAll(true)).called(1);
      });

      test(
          'updateCompletedById should update the completed status for a todo by its id',
          () async {
        final todo = Stubs.todoCompleted;
        when(todoRepository.updateCompletedById('1', true))
            .thenAnswer((_) async => todo);

        final result = await todoActionsService.updateCompletedById('1', true);

        expect(result, todo);
        verify(todoRepository.updateCompletedById('1', true)).called(1);
      });

      test('deleteCompleted should delete all completed todos', () async {
        final todos = [
          Stubs.todoCompleted,
          Stubs.todoCompleted.copyWith(id: '2'),
        ];
        when(todoRepository.deleteCompleted()).thenAnswer((_) async => todos);

        final result = await todoActionsService.deleteCompleted();

        expect(result, todos);
        verify(todoRepository.deleteCompleted()).called(1);
      });
    });
  });
}
