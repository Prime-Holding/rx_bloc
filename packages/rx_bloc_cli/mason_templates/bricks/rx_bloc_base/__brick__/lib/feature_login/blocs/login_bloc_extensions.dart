{{> licence.dart }}

part of 'login_bloc.dart';

extension _UserAccountBlocExtensions on LoginBloc {
  Stream<bool> _validateAllFields() => Rx.combineLatest2<String, String, bool>(
        username,
        password,
        (username, password) => true,
      ).onErrorReturn(false);
}

extension _VoidStreamExtensions on Stream<void> {
  Stream<CredentialsModel> validateCredentials(LoginBloc bloc) =>
      switchMap((value) => bloc._validateAllFields())
          .where((isValid) => isValid)
          .withLatestFrom2(
              bloc.states.username,
              bloc.states.password,
              (_, String username, String password) =>
                  CredentialsModel(username, password))
          .distinct((previousCredentials, currentCredentials) =>
              currentCredentials.equals(previousCredentials));
}

extension _FieldStreamExtensions on Stream<Exception> {
  Stream<String> mapToFieldException(BehaviorSubject<String> password) => map(
        (event) => throw FieldErrorModel(
          errorKey: I18nErrorKeys.passwordLength,
          fieldValue: password.value,
        ),
      );
}
