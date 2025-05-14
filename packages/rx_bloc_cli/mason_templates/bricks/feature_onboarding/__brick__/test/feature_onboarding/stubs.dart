{{> licence.dart }}

import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';
import 'package:{{project_name}}/base/models/user_with_auth_token_model.dart';
import 'package:{{project_name}}/lib_auth/models/auth_token_model.dart';

class Stubs {
  static const email = 'example@example.com';

  static const password = 'password';

  static final user = UserWithAuthTokenModel(
    authToken: AuthTokenModel('token', 'refreshToken'),
    user: UserModel(
      id: 'id',
      email: email,
      hasPin: false,
      phoneNumber: password,
      role: UserRole.user,
      confirmedCredentials:
          ConfirmedCredentialsModel(email: true, phone: false),
    ),
  );
}
