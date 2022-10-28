// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import '../models/counter/increment_operation.dart';
import '../models/reminder/reminder_model.dart';
import '../models/updated_counters.dart';

part 'coordinator_bloc.rxb.g.dart';

part 'coordinator_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class CoordinatorEvents {
  void authenticated({required bool isAuthenticated});

  void reminderDeleted(Result<ReminderModel> reminderResult);

  void reminderCreated(Result<ReminderModel> reminderResult);

  void reminderUpdated(Result<ReminderPair> reminderPairResult);

  void updateCounters(UpdatedCounters counters);
}

abstract class CoordinatorStates {
  @RxBlocIgnoreState()
  Stream<bool> get isAuthenticated;

  @RxBlocIgnoreState()
  Stream<Result<ReminderModel>> get onReminderDeleted;

  @RxBlocIgnoreState()
  Stream<Result<ReminderPair>> get onReminderUpdated;

  @RxBlocIgnoreState()
  Stream<Result<ReminderModel>> get onReminderCreated;

  @RxBlocIgnoreState()
  Stream<UpdatedCounters> get onCountersUpdated;
}

/// The coordinator bloc manages the communication between blocs.
///
/// The goals is to keep all blocs decoupled from each other
/// as the entire communication flow goes through this bloc.
@RxBloc()
class CoordinatorBloc extends $CoordinatorBloc {
  @override
  Stream<bool> get isAuthenticated => _$authenticatedEvent;

  @override
  Stream<Result<ReminderModel>> get onReminderCreated => _$reminderCreatedEvent;

  @override
  Stream<Result<ReminderModel>> get onReminderDeleted => _$reminderDeletedEvent;

  @override
  Stream<Result<ReminderPair>> get onReminderUpdated => _$reminderUpdatedEvent;

  @override
  Stream<UpdatedCounters> get onCountersUpdated => _$updateCountersEvent;
}

extension CoordinatingTasksX on CoordinatorBlocType {
  /// Merge the following events with the value of the given [subject]
  /// and emits the result as a new event.
  ///
  /// Supported events:
  /// - reminder create [CoordinatorStates.onReminderCreated]
  ///
  /// Based on the result of the callback [onCreateOperation] the newly create task
  ///  will/will not be merged into the value of the provided [subject].
  // Stream<ManagedListCounterOperation<ReminderModel>>
  // mapReminderManageEventsWithLatestFromCreate(
  //     Stream<List<ReminderModel>> reminderList, {
  //       required Future<ManageOperation> Function(Identifiable model,
  //           [List<ReminderModel>? list])
  //       operationCallback,
  //     }) =>
  // states.onReminderCreated
  //     .whereSuccess()
  //     .withLatestFromIdentifiableList(
  //   reminderList,
  //   operationCallback: operationCallback,
  // )
  //     .map((managedList) =>
  //     ManagedListCounterOperation<ReminderModel>(
  //         managedList: managedList,
  //         counterOperation: CounterOperation.create));

  /// Merge the following events with the value of the given [subject]
  /// and emits the result as a new event.
  ///
  /// Supported events:
  /// - reminder update [CoordinatorStates.onReminderUpdated]
  /// - reminder delete [CoordinatorStates.onReminderDeleted]
  ///
  /// Based on the result of the callback [onDeleteOperation] the deleted task
  ///  will be deleted from the value of the provided [subject].
  ///
  /// Based on the result of the callback [onUpdateOperation] the updated task
  ///  will/will not be removed from value of the provided [subject].
  Stream<ManagedListCounterOperation<ReminderModel>>
      mapReminderManageEventsWithLatestFrom(
    Stream<List<ReminderModel>> reminderList, {
    required Future<ManageOperation> Function(Identifiable model,
            [List<ReminderModel>? list])
        operationCallback,
  }) =>
          Rx.merge([
            states.onReminderCreated
                .whereSuccess()
                .withLatestFromIdentifiableList(
                  reminderList,
                  operationCallback: operationCallback,
                )
                .map((managedList) =>
                    ManagedListCounterOperation<ReminderModel>(
                        managedList: managedList,
                        counterOperation: CounterOperation.create)),
            states.onReminderDeleted
                .whereSuccess()
                .withLatestFromIdentifiableList(
                  reminderList,
                  operationCallback: (Identifiable reminder,
                          [List<ReminderModel>? list]) async =>
                      ManageOperation.remove,
                )
                .map((managedList) =>
                    ManagedListCounterOperation<ReminderModel>(
                        managedList: managedList,
                        counterOperation: CounterOperation.delete)),
            states.onReminderUpdated.whereSuccess().switchMap((event) {
              var stream =
                  Stream.value(event.updated).withLatestFromIdentifiableList(
                reminderList,
                operationCallback: operationCallback,
              );
              return stream.map((streamEvent) => ManagedListWrapper(
                  managedList: streamEvent, oldReminder: event.old));
            }).switchMap((managedListWrapper) async* {
              yield ManagedListCounterOperation<ReminderModel>(
                  managedList: managedListWrapper.managedList
                      as ManagedList<ReminderModel>,
                  oldReminder: managedListWrapper.oldReminder,
                  counterOperation: CounterOperation.update);
            }),
          ]);
}

class ManagedListWrapper {
  ManagedListWrapper({required this.managedList, required this.oldReminder});

  ManagedList managedList;

  ReminderModel oldReminder;
}
