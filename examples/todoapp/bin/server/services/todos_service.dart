import 'package:todoapp/base/models/todo_model.dart';

import '../models/todo_model_list.dart';
import '../repositories/todos_repository.dart';

class TodosService {
  final TodosRepository remindersRepository;
  TodosService(this.remindersRepository);

  TodoModelList fetchAllTodos() => remindersRepository.fetchAllTodos();

  TodoModel addOrUpdateReminder(TodoModel reminder) =>
      remindersRepository.addOrUpdateTodo(reminder);

  TodoModel updateCompletedById(String id) =>
      remindersRepository.updateCompletedById(id);

  TodoModelList updateCompletedForAll(bool completed) =>
      remindersRepository.updateCompletedForAll(completed);

  TodoModelList deleteCompleted() => remindersRepository.deleteCompleted();

  void deleteById(String id) => remindersRepository.deleteById(id);

  TodoModel fetchTodoById(String id) => remindersRepository.fetchTodoById(id);
}
