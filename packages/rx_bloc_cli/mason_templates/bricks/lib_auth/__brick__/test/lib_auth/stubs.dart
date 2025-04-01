import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';
import 'package:{{project_name}}/base/models/user_with_auth_token_model.dart';
import 'package:{{project_name}}/lib_auth/models/auth_token_model.dart';

class Stubs {
  static const email = 'someone@email.com';

  static const password = 'secret';

  static const authToken = 'sometoken';

  static const refreshToken = 'somerefreshtoken';

  static final authTokenModel = AuthTokenModel(authToken, refreshToken);

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
  );

  static final userWithAuthTokenModel = UserWithAuthTokenModel(
    user: Stubs.userModel,
    authToken: Stubs.authTokenModel,
  );
}
