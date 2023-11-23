import 'dart:async';

import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../base/services/reminders_service.dart';

part 'reminder_manage_bloc.rxb.g.dart';

part 'reminder_manage_bloc_extensions.dart';

/// A contract class containing all events of the ReminderManageBloC.
abstract class ReminderManageBlocEvents {
  /// Event used to update the current model with the provided reminder model
  void update(ReminderModel reminder);

  /// Event used to update the name of the current model
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setName(String title);

  /// Event used to initiate creation of a new reminder with the provided
  /// due date and completion status
  void create({
    required DateTime dueDate,
    required bool complete,
  });

  /// Event used to delete the provided reminder
  void delete(ReminderModel reminder);
}

/// A contract class containing all states of the ReminderManageBloC.
abstract class ReminderManageBlocStates {
  /// State emitting the reminder once it has been deleted
  ConnectableStream<Result<ReminderModel>> get onDeleted;

  /// State emitting a pair of reminders (old and new reminder) once the
  /// reminder has been updated
  ConnectableStream<Result<ReminderPair>> get onUpdated;

  /// State emitting once a new reminder has been created
  ConnectableStream<Result<ReminderModel>> get onCreated;

  /// State storing the name of the current reminder
  Stream<String> get name;

  /// State indicating whether or not to show errors in the UI
  Stream<bool> get showErrors;

  /// State indicating whether or not the form used to update reminder name
  /// is valid
  Stream<bool> get isFormValid;
}

@RxBloc()
class ReminderManageBloc extends $ReminderManageBloc {
  ReminderManageBloc(this._service, this._coordinatorBloc) {
    onDeleted.connect().addTo(_compositeSubscription);
    onUpdated.connect().addTo(_compositeSubscription);
    onCreated.connect().addTo(_compositeSubscription);
  }

  final RemindersService _service;
  final CoordinatorBlocType _coordinatorBloc;

  static const _nameValidation = 'A title must be specified';

  @override
  Stream<bool> _mapToShowErrorsState() => _$createEvent
      .isReminderNameValid(this)
      .map((event) => !event)
      .startWith(false)
      .shareReplay(maxSize: 1);

  @override
  ConnectableStream<Result<ReminderModel>> _mapToOnCreatedState() =>
      _$createEvent
          .validateNameFieldWithLatestFrom(this)
          .where((event) => event.isReminderNameValid)
          .switchMap(
            (createArgsAndIsNameValid) => _service
                .create(
                  title: createArgsAndIsNameValid.name!,
                  dueDate: createArgsAndIsNameValid.createEventArgs!.dueDate,
                  complete: createArgsAndIsNameValid.createEventArgs!.complete,
                )
                .asResultStream(),
          )
          .setResultStateHandler(this)
          .doOnData(_coordinatorBloc.events.reminderCreated)
          .publish();

  @override
  ConnectableStream<Result<ReminderModel>> _mapToOnDeletedState() =>
      _$deleteEvent
          .switchMap((reminder) => _service
              .delete(reminder.id)
              .asStream()
              .mapTo(reminder)
              .asResultStream())
          .setResultStateHandler(this)
          .doOnData(_coordinatorBloc.events.reminderDeleted)
          .publish();

  @override
  ConnectableStream<Result<ReminderPair>> _mapToOnUpdatedState() =>
      _$updateEvent
          .switchMap((reminder) => _service.update(reminder).asResultStream())
          .setResultStateHandler(this)
          .doOnData(_coordinatorBloc.events.reminderUpdated)
          .publish();

  @override
  Stream<String> _mapToNameState() => _$setNameEvent.map(validateName);

  String validateName(String name) {
    if (name.trim().isEmpty) {
      throw RxFieldException(
        fieldValue: name,
        error: _nameValidation,
      );
    }

    return name;
  }

  @override
  Stream<bool> _mapToIsFormValidState() => Rx.combineLatest<String, bool>(
        [name],
        (values) {
          return true;
        },
      ).onErrorReturn(false).asBroadcastStream();
}

class _CreateArgsAndIsNameValid {
  _CreateArgsAndIsNameValid(
      this.createEventArgs, this.name, this.isReminderNameValid);

  final _CreateEventArgs? createEventArgs;
  final String? name;
  final bool isReminderNameValid;
}
