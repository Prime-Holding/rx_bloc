import 'dart:async';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todoapp/base/common_services/todo_list_service.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/base/repositories/connectivity_repository.dart';
import 'package:todoapp/base/repositories/todo_repository.dart';
import '../../stubs.dart';
import 'todo_list_service_test.mocks.dart';

@GenerateMocks([TodoRepository, ConnectivityRepository])
void main() {
  group('TodoListService', () {
    late TodoListService todoListService;
    late MockTodoRepository todoRepository;
    late MockConnectivityRepository connectivityRepository;
    late StreamController<bool> connectivityStreamController;

    setUp(() {
      todoRepository = MockTodoRepository();
      connectivityRepository = MockConnectivityRepository();
      connectivityStreamController = StreamController<bool>();
      when(connectivityRepository.connected())
          .thenAnswer((_) => connectivityStreamController.stream);
      todoListService = TodoListService(todoRepository, connectivityRepository);
    });

    tearDown(() {
      connectivityStreamController.close();
    });

    test('fetchTodoList should return a stream of sorted todos', () {
      final todos = Stubs.todoList;

      when(todoRepository.fetchAllTodos())
          .thenAnswer((_) => Stream.value(todos));

      final result = todoListService.fetchTodoList();

      expect(result, emitsInOrder([todos]));
    });

    test('fetchTodoById should return the correct todo', () async {
      when(todoRepository.fetchTodoById('1'))
          .thenAnswer((_) => Future.value(Stubs.todoIncomplete));

      final todo = todoListService.fetchTodoById('1');

      expect(todo, emitsInOrder([Stubs.todoIncomplete]));
    });

    test('fetchTodoById should return the same todo by checking the id',
        () async {
      when(todoRepository.fetchTodoById('1'))
          .thenAnswer((_) => Future.value(Stubs.todoIncomplete));

      final todo = todoListService.fetchTodoById('1', Stubs.todoIncomplete);

      expect(todo, emitsInOrder([Stubs.todoIncomplete]));
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

    test('synchronizeTodos should sync and update todos correctly', () async {
      // Arrange
      final mockUnsyncedTodos = [Stubs.todoUnsynced];
      final mockSyncedTodos = [Stubs.getIncompleteTodo()];

      when(todoRepository.fetchAllUnsyncedTodos())
          .thenAnswer((_) => Future.value(mockUnsyncedTodos));
      when(todoRepository.syncTodos({'todos': mockUnsyncedTodos}))
          .thenAnswer((_) => Future.value(mockSyncedTodos));

      // Act
      await todoListService.synchronizeTodos();

      // Assert
      verify(todoRepository.fetchAllUnsyncedTodos()).called(1);
      verify(todoRepository.unpauseRealmSync()).called(1);
      verify(todoRepository.syncTodos({'todos': mockUnsyncedTodos})).called(1);
      verify(todoRepository.deleteMany(mockUnsyncedTodos)).called(1);
      verify(todoRepository.addMany(mockSyncedTodos)).called(1);
    });

    test('synchronizeTodos should not sync if there are no unsynced todos',
        () async {
      // Arrange
      final mockUnsyncedTodos = Stubs.todoListEmpty;

      when(todoRepository.fetchAllUnsyncedTodos())
          .thenAnswer((_) => Future.value(mockUnsyncedTodos));

      // Act
      await todoListService.synchronizeTodos();

      // Assert
      verify(todoRepository.fetchAllUnsyncedTodos()).called(1);
      verifyNever(todoRepository.unpauseRealmSync());
      verifyNever(todoRepository.syncTodos(any));
      verifyNever(todoRepository.deleteMany(any));
      verifyNever(todoRepository.addMany(any));
    });

    test('should call synchronizeTodos when event is true', () async {
      // Arrange
      when(todoRepository.fetchAllUnsyncedTodos())
          .thenAnswer((_) => Future.value(Stubs.todoListEmpty));
      when(connectivityRepository.connected())
          .thenAnswer((_) => Stream.value(false));

      when(todoRepository.syncTodos(any))
          .thenAnswer((_) async => Stubs.todoList);

      // Act
      todoListService = TodoListService(
        todoRepository,
        connectivityRepository,
      );

      // Assert
      verifyNever(todoRepository.syncTodos(any));
      verifyNever(todoRepository.pauseRealmSync());
    });
    test('should call synchronizeTodos when event is true', () async {
      // Arrange
      final mockUnsyncedTodos = [Stubs.todoUnsynced];
      final mockSyncedTodos = [Stubs.getIncompleteTodo()];

      when(todoRepository.fetchAllUnsyncedTodos())
          .thenAnswer((_) => Future.value(mockUnsyncedTodos));
      when(todoRepository.syncTodos({'todos': mockUnsyncedTodos}))
          .thenAnswer((_) => Future.value(mockSyncedTodos));
      when(connectivityRepository.connected())
          .thenAnswer((_) => Stream.value(true).asBroadcastStream());

      // Act
      todoListService = TodoListService(
        todoRepository,
        connectivityRepository,
      );

      // Assert
      await untilCalled(todoRepository.syncTodos(any));
      verify(todoRepository.syncTodos(any)).called(1);
      verifyNever(todoRepository.pauseRealmSync());
    });
  });
}
