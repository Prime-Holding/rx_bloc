import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/common_mappers/error_mappers/error_mapper.dart';
import 'package:todoapp/base/data_sources/remote/todos_remote_data_source.dart';
import 'package:todoapp/base/repositories/todo_repository.dart';

import '../../stubs.dart';
import 'todo_repository_test.mocks.dart';

@GenerateMocks([ErrorMapper, TodosRemoteDataSource])
void main() {
  late ErrorMapper mockErrorMapper;
  late MockTodosRemoteDataSource mockTodosRemoteDataSource;
  late TodoRepository todoRepository;

  setUp(() {
    mockErrorMapper = ErrorMapper(CoordinatorBloc());
    mockTodosRemoteDataSource = MockTodosRemoteDataSource();
    todoRepository = TodoRepository(mockErrorMapper, mockTodosRemoteDataSource);
  });

  group('TodoRepository', () {
    final todo = Stubs.todoIncomplete;
    final todoList = Stubs.todoList;

    test('fetchAllTodos returns list of todos', () async {
      when(mockTodosRemoteDataSource.getAllTodos())
          .thenAnswer((_) async => todoList);

      final result = await todoRepository.fetchAllTodos();

      expect(result, todoList);

      verify(mockTodosRemoteDataSource.getAllTodos()).called(1);
    });

    test('addTodo returns added todo', () async {
      when(mockTodosRemoteDataSource.addTodo(todo))
          .thenAnswer((_) async => todo);

      final result = await todoRepository.addTodo(todo);

      expect(result, todo);
      verify(mockTodosRemoteDataSource.addTodo(todo)).called(1);
    });

    test('updateTodoById returns updated todo', () async {
      when(mockTodosRemoteDataSource.updateTodoById('1', todo))
          .thenAnswer((_) async => todo);

      final result = await todoRepository.updateTodoById('1', todo);

      expect(result, todo);
      verify(mockTodosRemoteDataSource.updateTodoById('1', todo)).called(1);
    });

    test(
        'updateCompletedById updates completed status and returns updated todo',
        () async {
      when(mockTodosRemoteDataSource.updateCompletedById(
          '1', {'completed': true})).thenAnswer((_) async => todo);

      final result = await todoRepository.updateCompletedById('1', true);

      expect(result, todo);
      verify(mockTodosRemoteDataSource
          .updateCompletedById('1', {'completed': true})).called(1);
    });

    test(
        'updateCompletedForAll updates completed status for all todos and returns updated list',
        () async {
      when(mockTodosRemoteDataSource.updateCompletedForAll({'completed': true}))
          .thenAnswer((_) async => todoList);

      final result = await todoRepository.updateCompletedForAll(true);

      expect(result, todoList);
      verify(mockTodosRemoteDataSource
          .updateCompletedForAll({'completed': true})).called(1);
    });

    test('deleteCompleted deletes completed todos and returns updated list',
        () async {
      when(mockTodosRemoteDataSource.deleteCompleted())
          .thenAnswer((_) async => todoList);

      final result = await todoRepository.deleteCompleted();

      expect(result, todoList);
      verify(mockTodosRemoteDataSource.deleteCompleted()).called(1);
    });

    test('deleteTodoById deletes a todo by id', () async {
      when(mockTodosRemoteDataSource.deleteTodoById('1'))
          .thenAnswer((_) async {});

      await todoRepository.deleteTodoById('1');

      verify(mockTodosRemoteDataSource.deleteTodoById('1')).called(1);
    });

    test('fetchTodoById returns a todo by id', () async {
      when(mockTodosRemoteDataSource.getTodoById('1'))
          .thenAnswer((_) async => todo);

      final result = await todoRepository.fetchTodoById('1');

      expect(result, todo);
      verify(mockTodosRemoteDataSource.getTodoById('1')).called(1);
    });
  });
}
