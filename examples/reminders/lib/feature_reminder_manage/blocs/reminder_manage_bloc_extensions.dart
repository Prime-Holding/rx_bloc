part of 'reminder_manage_bloc.dart';

extension _ValidateReminderNameField<T> on Stream<_CreateEventArgs> {
  Stream<_CreateArgsAndIsNameValid> validateReminderNameFieldWithLatestFrom(
    ReminderManageBloc bloc,
  ) =>
      withLatestFrom3(
          bloc._name, bloc.states.isNameValid, bloc.states.nameErrorMessage,
          (args, String name, bool isValid, String? error) {
        if (isValid) {
          return _CreateArgsAndIsNameValid(args, name, true);
        }
        return _CreateArgsAndIsNameValid(null, null, false);
      }).onErrorReturn(_CreateArgsAndIsNameValid(null, null, false));
}

extension _ReminderManageBloc on ReminderManageBloc {
  String? validateReminderName(String name) {
    if (name.trim().isEmpty) {
      return 'A title must be specified.';
    }
    return null;
  }
}
