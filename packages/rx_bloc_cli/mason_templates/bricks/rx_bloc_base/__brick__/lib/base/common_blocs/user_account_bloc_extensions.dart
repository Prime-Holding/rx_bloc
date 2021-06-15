part of 'user_account_bloc.dart';

extension _UserAccountBlocExtensions on UserAccountBloc {
  Stream<bool> _validateAllFields() => Rx.combineLatest2<String, String, bool>(
        username,
        password,
        (email, password) => true,
      ).onErrorReturn(false);

  void _resetCredentials() {
    // Reset the current username and password
    setUsername('');
    setPassword('');
  }
}

extension _PublishStreamVoidExtensions on PublishSubject<void> {
  Stream<_LoginCredentials> validateCredentials(UserAccountBloc _bloc) =>
      switchMap((value) => _bloc._validateAllFields())
          .where((isValid) => isValid)
          .withLatestFrom2(
              _bloc._$setUsernameEvent,
              _bloc._$setPasswordEvent,
              (_, String username, String password) =>
                  _LoginCredentials(username, password));
}
