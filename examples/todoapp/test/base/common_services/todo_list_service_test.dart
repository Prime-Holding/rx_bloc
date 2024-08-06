import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todoapp/base/common_services/todo_list_service.dart';
import 'package:todoapp/base/extensions/todo_list_extensions.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/base/repositories/todo_repository.dart';
import '../../stubs.dart';
import 'todo_list_service_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  group('TodoListService', () {
    late TodoListService todoListService;
    late MockTodoRepository todoRepository;

    setUp(() {
      todoRepository = MockTodoRepository();
      todoListService = TodoListService(todoRepository);
    });

    test('fetchTodoList should return a sorted list of todos', () async {
      when(todoRepository.fetchAllTodos())
          .thenAnswer((_) => Future.value(Stubs.todoList));

      final todos = await todoListService.fetchTodoList();

      expect(todos, Stubs.todoList.sortByCreatedAt());
    });

    test('fetchTodoById should return the correct todo', () async {
      when(todoRepository.fetchTodoById('1'))
          .thenAnswer((_) => Future.value(Stubs.todoIncomplete));

      final todo = await todoListService.fetchTodoById('1');

      expect(todo.id, '1');
    });

    test('fetchTodoById should return the same todo by checking the id',
        () async {
      when(todoRepository.fetchTodoById('1'))
          .thenAnswer((_) => Future.value(Stubs.todoIncomplete));

      final todo =
          await todoListService.fetchTodoById('1', Stubs.todoIncomplete);

      expect(todo, Stubs.todoIncomplete);
    });

    test('filterTodos should return the correct filtered todos', () {
      final incompleteTodos = Stubs.todoListAllIncomplete;
      final completedTodos = Stubs.todoListAllCompleted;
      final todos = [...incompleteTodos, ...completedTodos];
      final allTodos = todoListService.filterTodos(todos, TodosFilterModel.all);
      final incomplete = todoListService.filterTodos(
        todos,
        TodosFilterModel.incomplete,
      );
      final completed = todoListService.filterTodos(
        todos,
        TodosFilterModel.completed,
      );

      expect(allTodos, todos);
      expect(incomplete, incompleteTodos);
      expect(completed, completedTodos);
    });
  });
}
