part of 'reminder_manage_bloc.dart';

extension _ValidateReminderNameField<T> on Stream<_CreateEventArgs> {
  /// Validates the reminder name field and returns a status indicating if the
  /// provided reminder name is valid
  Stream<bool> isReminderNameValid(ReminderManageBloc bloc) => switchMap(
        (value) => Rx.combineLatest([bloc.name], (values) => true)
            .onErrorReturn(false),
      );

  /// Validates the reminder name field. Returns a model containing details
  /// about the reminder to be created and a status indicating if the provided
  /// reminder name is valid
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
