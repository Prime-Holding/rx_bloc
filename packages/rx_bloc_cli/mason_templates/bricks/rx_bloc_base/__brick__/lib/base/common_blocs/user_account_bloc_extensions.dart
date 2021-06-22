part of 'user_account_bloc.dart';

extension _UserAccountBlocExtensions on UserAccountBloc {
  Stream<bool> _validateAllFields() => Rx.combineLatest2<String, String, bool>(
        username,
        password,
        (username, password) => true,
      ).onErrorReturn(false);
}

extension _VoidStreamExtensions on Stream<void> {
  Stream<_LoginCredentials> validateCredentials(UserAccountBloc _bloc) =>
      switchMap((value) => _bloc._validateAllFields())
          .where((isValid) => isValid)
          .withLatestFrom2(
              _bloc.states.username,
              _bloc.states.password,
              (_, String username, String password) =>
                  _LoginCredentials(username, password))
          .distinct((previousCredentials, currentCredentials) =>
              currentCredentials.equals(previousCredentials));

  Stream<bool> logoutUser(UserAccountBloc bloc) =>
      switchMap((value) => bloc._logoutUseCase.execute().asResultStream())
          .setResultStateHandler(bloc)
          .whereSuccess()
          .map((_) => false);
}

extension _LoginCredentialsStreamExtensions on Stream<_LoginCredentials> {
  Stream<bool> loginUser(UserAccountBloc bloc) =>
      switchMap((args) => bloc._loginUseCase
          .execute(username: args.username, password: args.password)
          .asResultStream()).setResultStateHandler(bloc).whereSuccess();
}
