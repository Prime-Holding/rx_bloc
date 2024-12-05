import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reminders/base/common_blocs/coordinator_bloc.dart';
import 'package:reminders/base/models/reminder/reminder_model.dart';
import 'package:reminders/base/services/reminders_service.dart';
import 'package:reminders/feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../mocks/coordinator_mock.dart';
import '../../mocks/service_mocks.dart';
import '../../stubs.dart';

void main() {
  late RemindersService reminderService;
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorEvents coordinatorEvents;

  void defineWhen() {
    when(coordinatorBloc.events).thenReturn(coordinatorEvents);
    when(coordinatorEvents
            .reminderCreated(Result.success(Stubs.createdReminderNote)))
        .thenAnswer((_) {});
    when(coordinatorEvents
            .reminderDeleted(Result.success(Stubs.createdReminderNote)))
        .thenAnswer((_) {});
    when(coordinatorEvents
            .reminderUpdated(Result.success(Stubs.reminderPairNote)))
        .thenAnswer((_) {});
    when(reminderService.create(
      title: Stubs.noteNameValid,
      dueDate: Stubs.dueDate,
      complete: false,
    )).thenAnswer((_) => Future.value(Stubs.createdReminderNote));
    when(reminderService.delete(Stubs.createdReminderNote.id))
        .thenAnswer((_) async {});
    when(reminderService.update(Stubs.updatedReminderNote))
        .thenAnswer((_) => Future.value(Stubs.reminderPairNote));
    when(reminderService.validateName(Stubs.emptyString))
        .thenThrow(Stubs.fieldException(Stubs.emptyString));
    when(reminderService.validateName(Stubs.noteNameValid))
        .thenReturn(Stubs.noteNameValid);
  }

  ReminderManageBloc manageBloc() =>
      ReminderManageBloc(reminderService, coordinatorBloc);
  setUp(() {
    reminderService = createRemindersServiceMock();
    coordinatorBloc = coordinatorMockFactory();
    coordinatorEvents = coordinatorBloc.events;
  });

  group('test reminder_manage_bloc_dart state onDeleted', () {
    rxBlocTest<ReminderManageBloc, Result<ReminderModel>>(
        'test reminder_manage_bloc_dart state onDeleted',
        build: () async {
          defineWhen();
          return manageBloc();
        },
        act: (bloc) async {
          bloc.events.delete(Stubs.createdReminderNote);
        },
        state: (bloc) => bloc.states.onDeleted,
        expect: [
          isA<ResultLoading>(),
          isA<ResultSuccess<ReminderModel>>(),
        ]);
  });

  group('test reminder_manage_bloc_dart state onCreated', () {
    rxBlocTest<ReminderManageBloc, Result<ReminderModel>>(
        'test reminder_manage_bloc_dart state onCreated',
        build: () async {
          defineWhen();
          return manageBloc();
        },
        act: (bloc) async {
          bloc.states.name.listen((_) {});
          bloc.states.isFormValid.listen((_) {});
          bloc.events.setName(Stubs.noteNameValid);
          bloc.events.create(dueDate: Stubs.dueDate, complete: false);
        },
        state: (bloc) => bloc.states.onCreated,
        expect: [
          isA<ResultLoading>(),
          isA<ResultSuccess<ReminderModel>>(),
        ]);
  });

  group('test reminder_manage_bloc_dart state name', () {
    rxBlocTest<ReminderManageBloc, String>(
        'test reminder_manage_bloc_dart state name - invalid name',
        build: () async {
          defineWhen();
          return manageBloc();
        },
        act: (bloc) async => bloc.events.setName(Stubs.emptyString),
        state: (bloc) => bloc.states.name,
        expect: [emitsError(isA<RxFieldException<String>>())]);
    rxBlocTest<ReminderManageBloc, String>(
        'test reminder_manage_bloc_dart state name - valid name',
        build: () async {
          defineWhen();
          return manageBloc();
        },
        act: (bloc) async {
          bloc.events.setName(Stubs.noteNameValid);
        },
        state: (bloc) => bloc.states.name,
        expect: [
          Stubs.noteNameValid,
        ]);
  });

  group('test reminder_manage_bloc_dart state showErrors', () {
    rxBlocTest<ReminderManageBloc, bool>(
        'test reminder_manage_bloc_dart state showErrors - empty',
        build: () async {
          defineWhen();
          return manageBloc();
        },
        act: (bloc) async {
          bloc.states.name.listen((_) {});
          bloc.events.setName(Stubs.noteNameValid);
          bloc.events.create(dueDate: Stubs.dueDate, complete: false);
        },
        state: (bloc) => bloc.states.showErrors,
        expect: [false]);

    rxBlocTest<ReminderManageBloc, bool>(
        'test reminder_manage_bloc_dart state showErrors - has error',
        build: () async {
          defineWhen();
          return manageBloc();
        },
        act: (bloc) async {
          bloc.events.setName(Stubs.emptyString);
          bloc.events.create(dueDate: Stubs.dueDate, complete: false);
        },
        state: (bloc) => bloc.states.showErrors,
        expect: [false, true]);
  });

  group('test reminder_manage_bloc_dart state isFormValid', () {
    rxBlocTest<ReminderManageBloc, bool>(
        'test reminder_manage_bloc_dart state isFormValid - empty',
        build: () async {
          defineWhen();
          return manageBloc();
        },
        act: (bloc) async {
          bloc.states.name.listen((_) {});
        },
        state: (bloc) => bloc.states.isFormValid,
        expect: const Iterable.empty());
    rxBlocTest<ReminderManageBloc, bool>(
        'test reminder_manage_bloc_dart state isFormValid - name valid',
        build: () async {
          defineWhen();
          return manageBloc();
        },
        act: (bloc) async {
          bloc.events.setName(Stubs.noteNameValid);
        },
        state: (bloc) => bloc.states.isFormValid,
        expect: [true]);
    rxBlocTest<ReminderManageBloc, bool>(
        'test reminder_manage_bloc_dart state isFormValid - name invalid',
        build: () async {
          defineWhen();
          return manageBloc();
        },
        act: (bloc) async {
          bloc.events.setName(Stubs.emptyString);
        },
        state: (bloc) => bloc.states.isFormValid,
        expect: [false]);
  });
}
