{{> licence.dart }}

part of 'validators.dart';

class LoginFieldValidators {
  const LoginFieldValidators();

  static final _emailRexExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  String validateEmail(String email) {
    if (email.isEmpty) {
      throw RxFieldException(
        fieldValue: email,
        error: 'Email is required',
      );
    }
    if (!_emailRexExp.hasMatch(email)) {
      throw RxFieldException(
        fieldValue: email,
        error: 'Please enter a valid email',
      );
    }
    return email;
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      throw RxFieldException(
        fieldValue: password,
        error: 'Password is required',
      );
    }
    if (password.length < 6 || password.length > 64) {
      throw RxFieldException(
        fieldValue: password,
        error: 'Password should be at least 6 characters long',
      );
    }

    return password;
  }
}
