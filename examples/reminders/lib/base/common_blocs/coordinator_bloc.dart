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

import '../models/reminder/reminder_model.dart';

part 'coordinator_bloc.rxb.g.dart';

part 'coordinator_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class CoordinatorEvents {
  void authenticated({required bool isAuthenticated});

  void reminderDeleted(Result<ReminderModel> reminderResult);

  void reminderCreated(Result<ReminderModel> reminderResult);

  void reminderUpdated(Result<IdentifiablePair<ReminderModel>> reminderResult);
}

abstract class CoordinatorStates {
  @RxBlocIgnoreState()
  Stream<bool> get isAuthenticated;

  @RxBlocIgnoreState()
  Stream<Result<ReminderModel>> get onReminderDeleted;

  @RxBlocIgnoreState()
  Stream<Result<IdentifiablePair<ReminderModel>>> get onReminderUpdated;

  @RxBlocIgnoreState()
  Stream<Result<ReminderModel>> get onReminderCreated;
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
  Stream<Result<ReminderModel>> get onReminderUpdated => _$reminderUpdatedEvent;
}

extension CoordinatingTasksX on CoordinatorBlocType {
  /// Merge the following events with the value of the given [subject]
  /// and emits the result as a new event.
  ///
  /// Supported events:
  /// - reminder update [CoordinatorStates.onReminderUpdated]
  /// - reminder create [CoordinatorStates.onReminderCreated]
  /// - reminder delete [CoordinatorStates.onReminderDeleted]
  ///
  /// Based on the result of the callback [onCreateOperation] the newly create task
  ///  will/will not be merged into the value of the provided [subject].
  ///
  /// Based on the result of the callback [onUpdateOperation] the updated task
  ///  will/will not be removed from value of the provided [subject].
  Stream<ManagedList<ReminderModel>> mapReminderManageEventsWithLatestFrom(
    Stream<List<ReminderModel>> reminderList, {
    required Future<ManageOperation> Function(
            ReminderModel model, ReminderModel? identifiableInList)
        operationCallback,
  }) =>
      Rx.merge([
        states.onReminderCreated.whereSuccess().withLatestFromIdentifiableList(
              reminderList,
              CounterOperation.create,
              operationCallback: operationCallback,
            ),
        states.onReminderDeleted.whereSuccess().withLatestFromIdentifiableList(
              reminderList,
              CounterOperation.delete,
              operationCallback: (reminder, identifiableInList) async =>
                  ManageOperation.remove,
            ),
        // Rx.combineLatest2(
        //     states.onReminderUpdated.whereSuccess(),
        //     reminderList,
        //     (updated, list) => myMethod(
        //           CounterOperation.update,
        //           operationCallback: operationCallback,
        //         )),
        states.onReminderUpdated.whereSuccess().withLatestFromIdentifiableList(
              reminderList,
              CounterOperation.update,
              operationCallback: operationCallback,
            ),
      ]);

  // myMethod(
  //   CounterOperation update, {
  //   required Future<ManageOperation> Function(
  //           ReminderModel model, ReminderModel? identifiableInList)
  //       operationCallback,
  // }) {
  //   print('test1');
  // }
}
