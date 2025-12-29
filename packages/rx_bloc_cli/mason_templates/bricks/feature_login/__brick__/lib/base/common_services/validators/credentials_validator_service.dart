{{> licence.dart }}

import '../../../app_extensions.dart';
import '../../models/errors/error_model.dart';

class CredentialsValidatorService {
  const CredentialsValidatorService();

  static final _emailRexExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  String validateEmail(String email) {
    if (email.isEmpty) {
      throw FieldRequiredErrorModel(
        errorValue: S.current.email,
        fieldValue: email,
      );
    }
    if (!_emailRexExp.hasMatch(email)) {
      throw FieldErrorModel(
        errorValue: S.current.invalidEmail,
        fieldValue: email,
      );
    }
    return email;
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      throw FieldRequiredErrorModel(
        errorValue: S.current.password,
        fieldValue: password,
      );
    }
    if (password.length < 6 || password.length > 64) {
      throw FieldErrorModel(
        errorValue: S.current.passwordLength,
        fieldValue: password,
      );
    }

    return password;
  }
}
