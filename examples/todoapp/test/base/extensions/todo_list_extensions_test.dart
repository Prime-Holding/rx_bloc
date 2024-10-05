import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/base/extensions/todo_list_extensions.dart';

import '../../stubs.dart';

void main() {
  group('TodoListExtensions', () {
    test('sortByCreatedAt sorts the list by createdAt in descending order', () {
      final todoList = Stubs.todoListUnsorted;

      final sortedTodos = todoList.sortByCreatedAt();

      expect(sortedTodos, todoList.sortByCreatedAt());
    });

    test('sortByCreatedAt handles an empty list', () {
      final todos = Stubs.todoListEmpty;
      final sortedTodos = todos.sortByCreatedAt();

      expect(sortedTodos, []);
    });

    test('sortByCreatedAt handles a list with one item', () {
      final todos = [Stubs.todoIncomplete];
      final sortedTodos = todos.sortByCreatedAt();

      expect(sortedTodos, todos);
    });
  });
}
