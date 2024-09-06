import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_statistics/models/todo_stats_model.dart';
import 'package:todoapp/lib_router/router.dart';

class Stubs {
  static $TodoModel getIncompleteTodo() => todoIncomplete;

  static $TodoModel getCompletedTodo() => todoCompleted;
  static $TodoModel getUncompletedTodo() => todoCompleted.copyWith(
        completed: false,
      );
  static $TodoModel getUpdatedUncompletedTodo() => todoCompleted.copyWith(
        completed: false,
        title: 'new uncompleted',
      );

  static final $TodoModel todoIncomplete = $TodoModel.empty().copyWith(
        id: '1',
        title: 'test title',
        description: 'test description',
        completed: false,
        createdAt: 0,
      );
  static final $TodoModel todoUncompletedUpdated =
      todoIncomplete.copyWith(title: 'new uncompleted');

  static final $TodoModel todoCompleted = $TodoModel.empty().copyWith(
        id: '1',
        title: 'test title',
        description: 'test description',
        completed: true,
        createdAt: 0,
      );
  static final $TodoModel todoUnsynced = todoCompleted.copyWith(
      synced: false, action: TodoModelActions.update.name);

  static $TodoModel getEmptyTodo() => todoEmpty;

  static final TodoModel todoEmpty = $TodoModel.empty();

  static final List<$TodoModel> todoListEmpty = List<TodoModel>.empty();

  static const shortTitle = 'sh';

  static const longTitle = 'long title 123456789012345678901234567890';

  static const validTitle = 'test title';

  static final List<$TodoModel> todoList = List<$TodoModel>.from([
    todoIncomplete,
    todoCompleted,
    todoIncomplete.copyWith(id: '3'),
    todoCompleted.copyWith(id: '4')
  ]);

  static final List<$TodoModel> todoListAllCompleted = List<$TodoModel>.from([
    todoCompleted,
    todoCompleted.copyWith(id: '2'),
    todoCompleted.copyWith(id: '3'),
    todoCompleted.copyWith(id: '4')
  ]);

  static final List<$TodoModel> todoListAllIncomplete = List<$TodoModel>.from([
    todoIncomplete,
    todoIncomplete.copyWith(id: '2'),
    todoIncomplete.copyWith(id: '3'),
    todoIncomplete.copyWith(id: '4')
  ]);

  static const todoListStatistics = TodoStatsModel(completed: 2, incomplete: 2);
  static const todoListStatisticsEmpty =
      TodoStatsModel(completed: 0, incomplete: 0);

  static final notFoundError = NotFoundErrorModel();

  static final homePageRoute = TodoCreateRoute();
}
