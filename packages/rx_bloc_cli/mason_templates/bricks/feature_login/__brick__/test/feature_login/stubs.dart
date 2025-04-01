{{#enable_login}}import 'package:{{project_name}}/assets.dart';
import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';
{{/enable_login}}
class Stubs {
  static const email = 'something@test.com';

  static const password = 'password';{{#enable_login}}

  static final error = FieldErrorModel(
    errorKey: I18nErrorKeys.invalidEmail,
    fieldValue: email,
  );
  static final userModel = UserModel(
    id: 'someid',
    email: email,
    phoneNumber: '+1234567890',
    role: UserRole.user,
    confirmedCredentials: ConfirmedCredentialsModel(
      email: true,
      phone: true,
    ),
    hasPin: true,
  );{{/enable_login}}
}
