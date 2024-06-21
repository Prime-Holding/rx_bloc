import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';

class Stubs {
  static final todoUncompleted = TodoModel.empty().copyWith(
    id: '1',
    title: 'test title',
    description: 'test description',
    completed: false,
  );

  static final todoUncompletedUpdated =
      todoUncompleted.copyWith(id: '2', title: 'new uncompleted');

  static final todoCompleted = TodoModel.empty().copyWith(
    id: '1',
    title: 'test title',
    description: 'test description',
    completed: true,
  );

  static final todoEmpty = TodoModel.empty();

  static final todoListEmpty = List<TodoModel>.empty();

  static const shortTitle = 'sh';

  static final todoList = List<TodoModel>.from([
    todoUncompleted,
    todoCompleted,
    todoUncompleted.copyWith(id: '3'),
    todoCompleted.copyWith(id: '4')
  ]);

  static final notFoundError = NotFoundErrorModel();
}