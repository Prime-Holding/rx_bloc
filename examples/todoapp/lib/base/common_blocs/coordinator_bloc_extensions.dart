// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'coordinator_bloc.dart';

extension CoordinatorBinderExtensions on Stream<bool> {
  Stream<bool> emitAuthenticatedToCoordinator(
          CoordinatorBlocType coordinator) =>
      doOnData(
        (isAuthenticated) => coordinator.events.authenticated(
          isAuthenticated: isAuthenticated,
        ),
      );
}

extension CoordinatingTodoLists on CoordinatorBlocType {
  /// Merge the following events with the value of the given [subject]
  /// and emits the result as a new event.
  ///
  /// Supported events:
  /// - reminder update [CoordinatorStates.onTodoAddedOrUpdated]
  /// - reminder delete [CoordinatorStates.onTodoDeleted]
  ///
  /// Based on the result of the callback [onAddOrUpdateOperation] the updated task
  /// will/will not be removed/merged from value of the provided [subject].
  ///
  /// Based on the result of the callback [onDeleteOperation] the deleted task
  /// will be deleted from the value of the provided [subject].

  Stream<ManagedList<TodoModel>> mapTodoManageEventsWithLatestFrom(
    Stream<List<TodoModel>> todoList, {
    required OperationCallback<TodoModel> operationCallback,
  }) =>
      Rx.merge([
        states.onTodoAddedOrUpdated
            .whereSuccess()
            .withLatestFromIdentifiableList(
              todoList,
              operationCallback: operationCallback,
            ),
        states.onTodoDeleted.whereSuccess().withLatestFromIdentifiableList(
              todoList,
              operationCallback: operationCallback,
            ),
      ]);
}
