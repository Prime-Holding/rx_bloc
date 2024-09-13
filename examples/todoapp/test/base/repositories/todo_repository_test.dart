import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/common_mappers/error_mappers/error_mapper.dart';
import 'package:todoapp/base/data_sources/local/todo_local_data_source.dart';
import 'package:todoapp/base/data_sources/remote/todos_remote_data_source.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/base/repositories/todo_repository.dart';

import '../../stubs.dart';
import 'todo_repository_test.mocks.dart';

@GenerateMocks([ErrorMapper, TodosRemoteDataSource, TodoLocalDataSource])
void main() {
  late ErrorMapper mockErrorMapper;
  late MockTodosRemoteDataSource mockTodosRemoteDataSource;
  late TodoRepository todoRepository;
  late MockTodoLocalDataSource mockTodoLocalDataSource;

  setUp(() {
    mockErrorMapper = ErrorMapper(CoordinatorBloc());
    mockTodosRemoteDataSource = MockTodosRemoteDataSource();
    mockTodoLocalDataSource = MockTodoLocalDataSource();
    todoRepository = TodoRepository(
        mockErrorMapper, mockTodosRemoteDataSource, mockTodoLocalDataSource);
  });

  group('TodoRepository', () {
    final todo = Stubs.todoIncomplete;
    final todoList = Stubs.todoList;

    test('fetchAllTodos returns a stream of TodoModel list', () async {
      // Arrange
      final mockTodoList = [todo];
      when(mockTodoLocalDataSource.allTodos())
          .thenAnswer((_) => Stream.value(mockTodoList));

      // Act
      final result = todoRepository.fetchAllTodos();

      // Assert
      expect(await result.first, mockTodoList);
      verify(mockTodoLocalDataSource.allTodos()).called(1);
    });

    test('addTodo returns added todo when online', () async {
      when(mockTodosRemoteDataSource.addTodo(todo))
          .thenAnswer((_) async => todo);
      when(mockTodoLocalDataSource.addTodo(todo)).thenAnswer((_) => todo);

      final result = await todoRepository.addTodo(todo);

      expect(result, todo);
      verify(mockTodosRemoteDataSource.addTodo(todo)).called(1);
      verify(mockTodoLocalDataSource.addTodo(todo)).called(1);
    });

    test('addTodo returns added todo saved localy', () async {
      when(mockTodosRemoteDataSource.addTodo(todo))
          .thenThrow(NoConnectionErrorModel());
      when(mockTodoLocalDataSource.addTodo(any)).thenAnswer((_) => todo);

      final result = await todoRepository.addTodo(todo);

      expect(result, todo);
      verify(mockTodoLocalDataSource.addTodo(any)).called(1);
    });

    test('updateTodoById returns updated todo', () async {
      when(mockTodosRemoteDataSource.updateTodoById('1', todo))
          .thenAnswer((_) async => todo);
      when(mockTodoLocalDataSource.updateTodoById('1', todo))
          .thenAnswer((_) => todo);

      final result = await todoRepository.updateTodoById('1', todo);

      expect(result, todo);
      verify(mockTodosRemoteDataSource.updateTodoById('1', todo)).called(1);
      verify(mockTodoLocalDataSource.updateTodoById('1', todo)).called(1);
    });

    test('updateTodoById returns updated todo saved localy', () async {
      when(mockTodoLocalDataSource.updateTodoById(any, any))
          .thenAnswer((_) => todo);
      when(mockTodosRemoteDataSource.updateTodoById('1', todo))
          .thenThrow(NoConnectionErrorModel());

      final result = await todoRepository.updateTodoById('1', todo);

      expect(result, todo);
      verify(mockTodoLocalDataSource.updateTodoById(any, any)).called(1);
    });

    test(
        'updateCompletedById updates completed status and returns updated todo',
        () async {
      when(mockTodosRemoteDataSource.updateCompletedById(
          '1', {'completed': true})).thenAnswer((_) async => todo);
      when(mockTodoLocalDataSource.updateCompletedById('1', true))
          .thenAnswer((_) => todo as TodoModel);

      final result = await todoRepository.updateCompletedById('1', true);

      expect(result, todo);
      verify(mockTodosRemoteDataSource
          .updateCompletedById('1', {'completed': true})).called(1);
      verify(mockTodoLocalDataSource.updateCompletedById('1', true)).called(1);
    });

    test('updateCompleted returns updated todo saved localy', () async {
      when(
        mockTodoLocalDataSource.updateCompletedById('1', true,
            synced: false, action: TodoModelActions.update.name),
      ).thenAnswer((_) => todo as TodoModel);

      when(mockTodosRemoteDataSource.updateCompletedById(
          '1', {'completed': true})).thenThrow(NoConnectionErrorModel());

      final result = await todoRepository.updateCompletedById('1', true);

      expect(result, todo);
      verify(mockTodoLocalDataSource.updateCompletedById(any, any,
              synced: anyNamed('synced'), action: anyNamed('action')))
          .called(1);
    });

    test(
        'updateCompletedForAll updates completed status for all todos and returns updated list',
        () async {
      when(mockTodosRemoteDataSource.updateCompletedForAll({'completed': true}))
          .thenAnswer((_) async => todoList);
      when(mockTodoLocalDataSource.updateCompletedForAll(true))
          .thenAnswer((_) => todoList);

      final result = await todoRepository.updateCompletedForAll(true);

      expect(result, todoList);
      verify(mockTodosRemoteDataSource
          .updateCompletedForAll({'completed': true})).called(1);
      verify(mockTodoLocalDataSource.updateCompletedForAll(true)).called(1);
    });

    test('deleteCompleted deletes completed todos and returns updated list',
        () async {
      when(mockTodosRemoteDataSource.deleteCompleted())
          .thenAnswer((_) async => todoList);
      when(mockTodoLocalDataSource.deleteCompleted())
          .thenAnswer((_) => todoList);

      final result = await todoRepository.deleteCompleted();

      expect(result, todoList);
      verify(mockTodosRemoteDataSource.deleteCompleted()).called(1);
      verify(mockTodoLocalDataSource.deleteCompleted()).called(1);
    });

    test('deleteTodoById deletes a todo by id', () async {
      when(mockTodosRemoteDataSource.deleteTodoById('1'))
          .thenAnswer((_) async {});

      await todoRepository.deleteTodoById('1');

      verify(mockTodosRemoteDataSource.deleteTodoById('1')).called(1);
      verify(mockTodoLocalDataSource.deleteTodoById('1')).called(1);
    });

    test('fetchTodoById returns a todo by id', () async {
      when(mockTodoLocalDataSource.getTodoById('1')).thenAnswer((_) => todo);

      final result = await todoRepository.fetchTodoById('1');

      expect(result, todo);
      verify(mockTodoLocalDataSource.getTodoById('1')).called(1);
    });
  });

  test('fetchAllUnsyncedTodos returns a list of unsynced todos', () async {
    final todoList = Stubs.todoList;
    when(mockTodoLocalDataSource.fetchAllUnsyncedTodos())
        .thenAnswer((_) => todoList);

    final result = await todoRepository.fetchAllUnsyncedTodos();

    expect(result, todoList);
    verify(mockTodoLocalDataSource.fetchAllUnsyncedTodos()).called(1);
  });

  test('deleteMany deletes many todos', () async {
    final todoList = Stubs.todoList;
    when(mockTodoLocalDataSource.deleteMany(todoList)).thenAnswer((_) {});

    todoRepository.deleteMany(todoList);

    verify(mockTodoLocalDataSource.deleteMany(todoList)).called(1);
  });

  test('addMany adds many todos', () async {
    final todoList = Stubs.todoList;
    when(mockTodoLocalDataSource.addMany(todoList)).thenAnswer((_) {});

    todoRepository.addMany(todoList);

    verify(mockTodoLocalDataSource.addMany(todoList)).called(1);
  });

  test('syncTodos syncs todos', () async {
    final todoMap = {'1': Stubs.todoList};
    when(mockTodosRemoteDataSource.syncTodos(todoMap))
        .thenAnswer((_) async => Stubs.todoList);

    final result = await todoRepository.syncTodos(todoMap);

    expect(result, Stubs.todoList);
    verify(mockTodosRemoteDataSource.syncTodos(todoMap)).called(1);
  });
}
