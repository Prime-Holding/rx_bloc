{{#enable_login}}import 'package:{{project_name}}/assets.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
{{/enable_login}}
class Stubs {
  static const email = 'something@test.com';

  static const password = 'password';{{#enable_login}}

  static final error = FieldErrorModel(
    errorKey: I18nErrorKeys.invalidEmail,
    fieldValue: email,
  );{{/enable_login}}
}
