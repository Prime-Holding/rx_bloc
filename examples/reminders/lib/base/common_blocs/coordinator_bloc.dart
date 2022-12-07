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

extension CoordinatingReminderLists on CoordinatorBlocType {
  /// Merge the following events with the value of the given [subject]
  /// and emits the result as a new event.
  ///
  /// Supported events:
  /// - reminder update [CoordinatorStates.onReminderUpdated]
  /// - reminder delete [CoordinatorStates.onReminderDeleted]
  /// - reminder create [CoordinatorStates.onReminderCreated]
  ///
  /// Based on the result of the callback [onUpdateOperation] the updated task
  /// will/will not be removed from value of the provided [subject].
  ///
  /// Based on the result of the callback [onDeleteOperation] the deleted task
  /// will be deleted from the value of the provided [subject].
  ///
  /// Based on the result of the callback [onCreateOperation] the newly create task
  /// will/will not be merged into the value of the provided [subject].

  Stream<ManagedList<ReminderModel>> mapReminderManageEventsWithLatestFrom(
    Stream<List<ReminderModel>> reminderList, {
    required OperationCallback<ReminderModel> operationCallback,
  }) =>
      Rx.merge([
        states.onReminderCreated.whereSuccess().withLatestFromIdentifiableList(
              reminderList,
              operationCallback: operationCallback,
            ),
        states.onReminderDeleted.whereSuccess().withLatestFromIdentifiableList(
              reminderList,
              operationCallback:
                  (Identifiable reminder, List<ReminderModel> list) async =>
                      ManageOperation.remove,
            ),
        states.onReminderUpdated
            .whereSuccess()
            .map((pair) => pair.updated)
            .withLatestFromIdentifiableList(reminderList,
                operationCallback: operationCallback),
      ]);
}

extension CoordinatingCountersChanges on CoordinatorBlocType {
  Stream<CounterOperation> mapReminderManagedEventsToCounterOperation() =>
      Rx.merge([
        states.onReminderCreated.whereSuccess().mapTo(CounterOperation.create),
        states.onReminderDeleted.whereSuccess().map((reminder) =>
            reminder.complete
                ? CounterOperation.deleteComplete
                : CounterOperation.deleteIncomplete),
        states.onReminderUpdated.whereSuccess().map((pair) {
          if (pair.updated.complete != pair.old.complete) {
            return pair.updated.complete
                ? CounterOperation.setComplete
                : CounterOperation.unsetComplete;
          }
          return CounterOperation.none;
        }),
      ]);
}
