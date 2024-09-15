import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';
import 'package:todoapp/base/common_services/todo_list_service.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/base/repositories/todo_list_repository.dart';

import '../../stubs.dart';
import 'todo_list_service_test.mocks.dart';

@GenerateMocks([
  TodoListRepository,
])
void main() {
  late MockTodoListRepository mockRepository;
  late TodoListService todoListService;

  setUp(() {
    mockRepository = MockTodoListRepository();
    todoListService = TodoListService(mockRepository);
  });

  group('TodoListService', () {
    test('fetchTodoList returns sorted list of todos', () async {
      final todos = Stubs.todoList;
      when(mockRepository.fetchAllTodos()).thenAnswer((_) async => todos);

      final result = await todoListService.fetchTodoList();

      expect(result, equals(todos));
      verify(mockRepository.fetchAllTodos()).called(1);
    });

    test('fetchTodoById returns todo if already provided', () async {
      final todo = Stubs.todoIncomplete;

      final result = await todoListService.fetchTodoById('1', todo);

      expect(result, equals(todo));
      verifyNever(mockRepository.fetchTodoById(any));
    });

    test('fetchTodoById fetches todo from repository if not provided',
        () async {
      final todo = Stubs.todoIncomplete;
      when(mockRepository.fetchTodoById('1')).thenAnswer((_) async => todo);

      final result = await todoListService.fetchTodoById('1');

      expect(result, equals(todo));
      verify(mockRepository.fetchTodoById('1')).called(1);
    });

    test('filterTodos returns all todos when filter is all', () {
      final todos = Stubs.todoList;

      final result = todoListService.filterTodos(todos, TodosFilterModel.all);

      expect(result, equals(todos));
    });

    test('filterTodos returns incomplete todos when filter is incomplete', () {
      final todos = Stubs.todoList;

      final result =
          todoListService.filterTodos(todos, TodosFilterModel.incomplete);

      expect(
          result,
          equals(
            [todos[0], todos[2]],
          ));
    });

    test('filterTodos returns completed todos when filter is completed', () {
      final todos = Stubs.todoList;

      final result =
          todoListService.filterTodos(todos, TodosFilterModel.completed);

      expect(
          result,
          equals([
            todos[1],
            todos[3],
          ]));
    });
  });
}
