import 'package:todoapp/base/models/todo_model.dart';

import '../models/todo_model_list.dart';
import '../repositories/todos_repository.dart';

class TodosService {
  final TodosRepository todoRepository;
  TodosService(this.todoRepository);

  TodoModelList fetchAllTodos() => todoRepository.fetchAllTodos();

  TodoModel addTodo(String title, String? description) =>
      todoRepository.addTodo(title, description);

  TodoModel updateTodoById(String id, String title, String? description) =>
      todoRepository.updateTodoById(id, title, description);

  TodoModel updateCompletedById(String id) =>
      todoRepository.updateCompletedById(id);

  TodoModelList updateCompletedForAll(bool completed) =>
      todoRepository.updateCompletedForAll(completed);

  TodoModelList deleteCompleted() => todoRepository.deleteCompleted();

  void deleteById(String id) => todoRepository.deleteById(id);

  TodoModel fetchTodoById(String id) => todoRepository.fetchTodoById(id);
}
