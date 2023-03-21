{{> licence.dart }}

part of 'login_bloc.dart';

extension _UserAccountBlocExtensions on LoginBloc {
  Stream<bool> _validateAllFields() => Rx.combineLatest2<String, String, bool>(
        email,
        password,
        (username, password) => true,
      ).onErrorReturn(false);
}

extension _FieldStreamExtensions on Stream<Exception> {
  Stream<String> mapToFieldException(BehaviorSubject<String> password) => map(
        (event) => throw FieldErrorModel(
          errorKey: I18nErrorKeys.passwordLength,
          fieldValue: password.value,
        ),
      );
}
