import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../base/services/reminders_service.dart';

part 'reminder_manage_bloc.rxb.g.dart';

part 'reminder_manage_bloc_extensions.dart';

/// A contract class containing all events of the ReminderManageBloC.
abstract class ReminderManageBlocEvents {
  void update(ReminderModel reminder);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void setName(String title);

  void validate();

  void create({
    required DateTime dueDate,
    required bool complete,
    required bool completeUpdated,
  });

  void delete(ReminderModel reminder);
}

/// A contract class containing all states of the ReminderManageBloC.
abstract class ReminderManageBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  ConnectableStream<Result<ReminderModel>> get onDeleted;

  ConnectableStream<Result<IdentifiablePair<ReminderModel>>> get onUpdated;

  Stream<Result<ReminderModel>> get onCreated;

  Stream<String> get name;

  Stream<String?> get nameErrorMessage;

  Stream<bool> get isNameValid;
}

@RxBloc()
class ReminderManageBloc extends $ReminderManageBloc {
  ReminderManageBloc(this._service, this._coordinatorBloc) {
    onDeleted.connect().disposedBy(_compositeSubscription);
    onUpdated.connect().disposedBy(_compositeSubscription);
  }

  final RemindersService _service;
  final CoordinatorBlocType _coordinatorBloc;

  /// TODO: Implement error event-to-state logic
  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<Result<ReminderModel>> _mapToOnCreatedState() => _$createEvent
      .validateReminderNameFieldWithLatestFrom(this)
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
      .asBroadcastStream();

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
  ConnectableStream<Result<IdentifiablePair<ReminderModel>>>
      _mapToOnUpdatedState() => _$updateEvent
          .switchMap((reminder) => _service.update(reminder).asResultStream())
          .setResultStateHandler(this)
          .doOnData(_coordinatorBloc.events.reminderUpdated)
          .publish();

  @override
  Stream<String?> _mapToNameErrorMessageState() => _$validateEvent
      .switchMap(
        (_) => Rx.combineLatest<String?, String?>(
          [_name.isNameEmpty()],
          (values) {
            var error = values[0];
            if (error != null) {
              return error;
            }
            return null;
          },
        ),
      )
      .share();

  Stream<String> get _name => _$setNameEvent.share();

  @override
  Stream<bool> _mapToIsNameValidState() => nameErrorMessage
      .map((errorMessage) => errorMessage == null)
      .startWith(false)
      .share();

  @override
  Stream<String> _mapToNameState() => _$setNameEvent.asBroadcastStream();
}

class _CreateArgsAndIsNameValid {
  _CreateArgsAndIsNameValid(
      this.createEventArgs, this.name, this.isReminderNameValid);

  final _CreateEventArgs? createEventArgs;
  final String? name;
  final bool isReminderNameValid;
}
