part of 'reminder_manage_bloc.dart';

extension _ValidateReminderNameField<T> on Stream<_CreateEventArgs> {
  Stream<bool> isReminderNameValid(ReminderManageBloc bloc) => switchMap(
        (value) => Rx.combineLatest([bloc.name], (values) => true)
            .onErrorReturn(false),
      );

  Stream<_CreateArgsAndIsNameValid> validateNameFieldWithLatestFrom(
          ReminderManageBloc bloc) =>
      withLatestFrom2<String, bool, _CreateArgsAndIsNameValid>(
        bloc.states.name,
        bloc.states.isFormValid,
        (args, name, isFormValid) {
          if (isFormValid) {
            return _CreateArgsAndIsNameValid(args, name.trim(), true);
          }
          return _CreateArgsAndIsNameValid(null, null, false);
        },
      ).onErrorReturn(_CreateArgsAndIsNameValid(null, null, false));
}
