import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/common_services/todo_list_service.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/base/models/todos_filter_model.dart';
import 'package:todoapp/feature_todo_list/blocs/todo_list_bloc.dart';

import 'todo_list_test.mocks.dart';


@GenerateMocks([
        TodoListService,
        CoordinatorBlocType,
])

void main() {
  late TodoListService _todoListService;
  late CoordinatorBlocType _coordinatorBloc;

  void _defineWhen(/*value*/) {
     /*
            //Sample mock during a test case
            when(repository.fetchPage()).thenAnswer((_) async => value);
      */
  }

  TodoListBloc todoListBloc() => TodoListBloc(
        _todoListService,
        _coordinatorBloc,
);
  setUp(() {
      _todoListService = MockTodoListService();
    _coordinatorBloc = MockCoordinatorBlocType();

  });


  group('test todo_list_bloc_dart state todoList', () {
      rxBlocTest<TodoListBlocType, Result<List<TodoModel>>>('test todo_list_bloc_dart state todoList',
      build: () async {
          _defineWhen();
       return todoListBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.todoList,
      expect: []);
  });

  group('test todo_list_bloc_dart state filter', () {
      rxBlocTest<TodoListBlocType, TodosFilterModel>('test todo_list_bloc_dart state filter',
      build: () async {
          _defineWhen();
       return todoListBloc();
      },
      act: (bloc) async {},
      state: (bloc) => bloc.states.filter,
      expect: []);
  });

}