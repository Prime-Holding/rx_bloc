import 'package:realm/realm.dart';
import '../../models/todo_model.dart';

class TodoLocalDataSource {
  final Realm realm;
  TodoLocalDataSource(this.realm);

// .query(r'action != $0 SORT(createdAt ASC)', ['delete'])
  Stream<List<$TodoModel>> allTodos() => realm
      .all<TodoModel>()
      .query(r'action != $0 SORT(createdAt DESC)', ['delete'])
      .changes
      .map((element) => element.results.toList());

  void pauseSync() => realm.syncSession.pause();

  void unpauseSync() => realm.syncSession.resume();

  void addMany(List<$TodoModel> todos) {
    if (todos.isEmpty) return;
    realm.write(() {
      realm.addAll<TodoModel>(todos as List<TodoModel>);
    });
  }

  void deleteMany(List<$TodoModel> todos) {
    realm.write(() {
      realm.deleteMany(todos as List<TodoModel>);
    });
  }

  $TodoModel addTodo($TodoModel todo) {
    realm.write(() {
      realm.add<TodoModel>(todo as TodoModel);
    });
    return todo;
  }

  List<TodoModel> fetchAllUnsyncedTodos() {
    final results = realm.query<TodoModel>(r'synced == $0', [false]);
    return results.map((element) => element).toList();
  }

  List<TodoModel> fetchAllTodos() {
    final results = realm.query<TodoModel>(r'action != $0', ['delete']);
    return results.map((element) => element).toList();
  }

  $TodoModel updateTodoById(String id, $TodoModel todo) {
    final result = realm.find<TodoModel>(id);

    if (result == null) {
      throw Exception('Todo with id $id not found');
    }
    realm.write(() {
      result.title = todo.title;
      result.description = todo.description;
      result.completed = todo.completed;
      result.synced = todo.synced;
      result.action = todo.action;
    });
    return result;
  }

  TodoModel updateCompletedById(
    String id,
    bool completed, {
    bool synced = true,
    String? action,
  }) {
    final todo = realm.find<TodoModel>(id);

    if (todo == null) {
      throw Exception('Todo with id $id not found');
    }
    realm.write(() {
      todo.completed = completed;
      todo.synced = synced;
      todo.action = action ?? TodoModelActions.none.name;
    });
    return todo;
  }

  List<TodoModel> updateCompletedForAll(
    bool completed, {
    bool synced = true,
    String? action,
  }) {
    final results = realm.all<TodoModel>().query('completed != $completed');
    final todos = results.toList();
    realm.write(() {
      for (var todo in todos) {
        todo.completed = completed;
        todo.action = action ?? TodoModelActions.none.name;
        todo.synced = synced;
      }
    });
    return todos.map((element) => element).toList();
  }

  List<TodoModel> softDeleteCompleted({bool synced = true, String? action}) {
    final results = realm.all<TodoModel>().query('completed == true');
    final todos = results.toList();
    realm.write(() {
      for (var todo in todos) {
        ///Instead of deleting the todo, we will mark it for deletion
        todo.action = action ?? TodoModelActions.none.name;
        todo.synced = synced;
      }
    });
    return todos;
  }

  List<TodoModel> deleteCompleted({bool synced = true, String? action}) {
    final results = realm.all<TodoModel>().query('completed == true');
    final todos = results.toList();
    realm.write(() {
      for (var todo in todos) {
        realm.delete<TodoModel>(todo);
      }
    });
    return todos;
  }

  void deleteTodoById(
    String id, {
    bool synced = true,
    String? action,
  }) {
    final todo = realm.find<TodoModel>(id);

    if (todo == null) {
      throw Exception('Todo with id $id not found');
    }

    realm.write(() {
      realm.delete<TodoModel>(todo);
    });
  }

  void softDeleteTodoById(
    String id, {
    bool synced = true,
    String? action,
  }) {
    final todo = realm.find<TodoModel>(id);

    if (todo == null) {
      throw Exception('Todo with id $id not found');
    }

    ///Instead of deleting the todo, we will mark it for deletion
    realm.write(() {
      todo.action = action ?? TodoModelActions.delete.name;
      todo.synced = synced;
    });
  }

  $TodoModel getTodoById(String id) {
    final todo = realm.find<TodoModel>(id);

    if (todo == null) {
      throw Exception('Todo with id $id not found');
    }
    return todo;
  }
}
