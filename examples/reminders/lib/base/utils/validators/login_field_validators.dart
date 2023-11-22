// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'validators.dart';

/// A utility class containing all the validators for the login fields
class LoginFieldValidators {
  /// Default constructor
  const LoginFieldValidators();

  static final _emailRexExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// Validates an email. Returns the email if it is valid, otherwise throws a
  /// [RxFieldException] with the appropriate error message
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

  /// Performs a password validation. Returns the password if it is valid,
  /// otherwise throws a [RxFieldException] with the appropriate error message
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
