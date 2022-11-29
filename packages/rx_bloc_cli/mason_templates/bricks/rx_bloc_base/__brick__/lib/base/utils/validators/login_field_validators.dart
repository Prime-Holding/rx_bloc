{{> licence.dart }}

part of 'validators.dart';

class LoginFieldValidators {
  const LoginFieldValidators();

  static final _emailRexExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  String validateEmail(String email) {
    if (email.isEmpty) {
      throw FieldRequiredErrorModel(
        fieldKey: I18nFieldKeys.email,
        fieldValue: email,
      );
    }
    if (!_emailRexExp.hasMatch(email)) {
      throw FieldErrorModel(
        fieldKey: I18nErrorKeys.invalidEmail,
        fieldValue: email,
      );
    }
    return email;
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      throw FieldRequiredErrorModel(
        fieldKey: I18nFieldKeys.password,
        fieldValue: password,
      );
    }
    if (password.length < 6 || password.length > 64) {
      throw FieldErrorModel(
        fieldKey: I18nErrorKeys.passwordLength,
        fieldValue: password,
      );
    }

    return password;
  }
}
