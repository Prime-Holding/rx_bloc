part of 'login_bloc.dart';

extension _UserAccountBlocExtensions on LoginBloc {
  Stream<bool> _validateAllFields() => Rx.combineLatest2<String, String, bool>(
        username,
        password,
        (username, password) => true,
      ).onErrorReturn(false);
}

extension _VoidStreamExtensions on Stream<void> {
  Stream<_LoginCredentials> validateCredentials(LoginBloc _bloc) =>
      switchMap((value) => _bloc._validateAllFields())
          .where((isValid) => isValid)
          .withLatestFrom2(
              _bloc.states.username,
              _bloc.states.password,
              (_, String username, String password) =>
                  _LoginCredentials(username, password))
          .distinct((previousCredentials, currentCredentials) =>
              currentCredentials.equals(previousCredentials));
}

extension _LoginCredentialsStreamExtensions on Stream<_LoginCredentials> {
  Stream<Result<bool>> loginUser(LoginUseCase useCase) =>
      throttleTime(const Duration(seconds: 1)).switchMap(
        (args) => useCase
            .execute(username: args.username, password: args.password)
            .asResultStream(),
      );
}

extension _FieldStreamExtensions on Stream<Exception> {
  Stream<String> mapToFieldException(BehaviorSubject<String> password) => map(
        (event) => throw RxFieldException(
          error: 'Wrong email or password',
          fieldValue: password.value,
        ),
      );
}
